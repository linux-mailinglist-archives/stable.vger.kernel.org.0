Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182805AA03C
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 21:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiIATjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 15:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiIATjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 15:39:21 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352E799B6F
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 12:39:20 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id z22-20020a056830129600b0063711f456ceso23487otp.7
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 12:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tK+wx8BXoA3Qn9tpBrPoVGaZ14QtOl1QhPU+dOk5uhw=;
        b=DD2/jgcBYs2JYb4ITOIBhKmaeMaYLkngBQb8K3P0YXgTH29qSfVPKSeQCYNL/DiHAF
         IYqd08CYrbeVmrH8mdpyoy0X32IdrfEomc2ipU1H4dQSWM9MrP57k0wELnsr+oaumzSo
         aVXGuY8Y+zUJdI7o7SBzEw+cK0G8A6VX9azDSbyyS3p79l2sePFlKMLPO+1P+0R4P5ns
         g1ecqVcPBA0O3zMz0qF0NodReL758St/SI7gIYk3usF/aEmSWd/Q4CFmUSk6WFFl+0h2
         lgsD2oErvLiCtmu5olctJ6MS45mHPg5n/Bp7nWG1Qd8E6PDZitMai2jOW6X2G3aQAhqB
         a3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tK+wx8BXoA3Qn9tpBrPoVGaZ14QtOl1QhPU+dOk5uhw=;
        b=3hdOACl+jv9zay5oZnFGD+5SR0+GmY8xyke4GbeOsGTkSyRP5pfvakJ29CNG8yqqnk
         G7TdDbzOMp66/kUygVldT7JT8pq1Mo3cxmQAtan73R7Schk4R1v5mKCVChP8xf1sEyiF
         gmmTv5KF8iDDhUJtm5yrGHhYlacrcJxpOHHq+4/kRZdORdUTtKm0UOqCslTzziQnrMbg
         1TyXs6F6s/GQkeCpssNzn+AUs/SwV5EAmf1VfHiuLM2CmEKXbFrLVY4Qt8zrfNoRF+Uy
         /Vno9M3gaQ5vGRoJpDwihqwIeZvufkIrG/zkn1oEdID/7fqUGfxdtiyc/QOuUMhPs9pW
         eemg==
X-Gm-Message-State: ACgBeo3OUBFLchefGO/C9J4lar04rAgBKaLS289cuqvIrlxQk6FkK1/Q
        tBMYSY4OVqx6G1aUzPLnuISTk2M7/Dqg7eRy+6o=
X-Google-Smtp-Source: AA6agR4J1gpg31Wc2EZHoh5HD4EEPkvsbmitLUMUamy0utSzKf8R5mCmgPyycHIyLroQbINHgOEsY9zJmvAoJi9s12U=
X-Received: by 2002:a9d:6ad7:0:b0:636:f76b:638a with SMTP id
 m23-20020a9d6ad7000000b00636f76b638amr13433824otq.233.1662061159390; Thu, 01
 Sep 2022 12:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220829081752.1258274-1-lijo.lazar@amd.com> <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
 <3b2a9a8f-dedf-2781-0023-d6bd64f16d65@amd.com> <CADnq5_P0=+NNk2v_VOxyjOVSnY55SY=OX40xD5Bx6etspREnfA@mail.gmail.com>
 <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com> <CADnq5_Pkpe_-SH8Wh=_s6FXDFEWvO8rr5Ls2=Q4HRXy9+eSOBQ@mail.gmail.com>
 <9ef0287a-e463-d440-58fe-0323a6eca94a@amd.com> <CADnq5_P1VV2zWpjtsedPCoJH_CKv+d-MuVJwxOBbdpo1fLFCjA@mail.gmail.com>
In-Reply-To: <CADnq5_P1VV2zWpjtsedPCoJH_CKv+d-MuVJwxOBbdpo1fLFCjA@mail.gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 1 Sep 2022 15:39:07 -0400
Message-ID: <CADnq5_O1Z0FK99cKDmRuCoxg-hbD3LtcW1q3n4zvrB9xFo0XHw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm/amdgpu: Move HDP remapping earlier during init
To:     "Lazar, Lijo" <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Felix.Kuehling@amd.com,
        stable@vger.kernel.org, tseewald@gmail.com, helgaas@kernel.org,
        Alexander.Deucher@amd.com, sr@denx.de, Christian.Koenig@amd.com,
        Hawking.Zhang@amd.com
Content-Type: multipart/mixed; boundary="000000000000007a7405e7a2c51e"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000007a7405e7a2c51e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

How about this?  We should just move HDP remap to gmc hw_init since
that is mainly what uses it anyway.

Alex

On Tue, Aug 30, 2022 at 2:05 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>
> On Tue, Aug 30, 2022 at 12:06 PM Lazar, Lijo <lijo.lazar@amd.com> wrote:
> >
> >
> >
> > On 8/30/2022 8:39 PM, Alex Deucher wrote:
> > > On Tue, Aug 30, 2022 at 10:45 AM Lazar, Lijo <lijo.lazar@amd.com> wro=
te:
> > >>
> > >>
> > >>
> > >> On 8/30/2022 7:18 PM, Alex Deucher wrote:
> > >>> On Tue, Aug 30, 2022 at 12:05 AM Lazar, Lijo <lijo.lazar@amd.com> w=
rote:
> > >>>>
> > >>>>
> > >>>>
> > >>>> On 8/29/2022 10:20 PM, Alex Deucher wrote:
> > >>>>> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> w=
rote:
> > >>>>>>
> > >>>>>> HDP flush is used early in the init sequence as part of memory c=
ontroller
> > >>>>>> block initialization. Hence remapping of HDP registers needed fo=
r flush
> > >>>>>> needs to happen earlier.
> > >>>>>>
> > >>>>>> This also fixes the Unsupported Request error reported through A=
ER during
> > >>>>>> driver load. The error happens as a write happens to the remap o=
ffset
> > >>>>>> before real remapping is done.
> > >>>>>>
> > >>>>>> Link: https://nam11.safelinks.protection.outlook.com/?url=3Dhttp=
s%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=3D05%7C=
01%7Clijo.lazar%40amd.com%7Cbe8781fe1b0c41d3bad408da8a99b3d8%7C3dd8961fe488=
4e608e11a82d994e183d%7C0%7C0%7C637974690005710507%7CUnknown%7CTWFpbGZsb3d8e=
yJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C=
%7C%7C&amp;sdata=3D98WWFEcwi2tzyf%2BxnYC%2FK3UcCE5mfXI00qfYGUpt2Sk%3D&amp;r=
eserved=3D0
> > >>>>>>
> > >>>>>> The error was unnoticed before and got visible because of the co=
mmit
> > >>>>>> referenced below. This doesn't fix anything in the commit below,=
 rather
> > >>>>>> fixes the issue in amdgpu exposed by the commit. The reference i=
s only
> > >>>>>> to associate this commit with below one so that both go together=
.
> > >>>>>>
> > >>>>>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting i=
n get_port_device_capability()")
> > >>>>>>
> > >>>>>> Reported-by: Tom Seewald <tseewald@gmail.com>
> > >>>>>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> > >>>>>> Cc: stable@vger.kernel.org
> > >>>>>
> > >>>>> How about something like the attached patch rather than these two
> > >>>>> patches?  It's a bit bigger but seems cleaner and more defensive =
in my
> > >>>>> opinion.
> > >>>>>
> > >>>>
> > >>>> Whenever device goes to suspend/reset and then comes back, remap o=
ffset
> > >>>> has to be set back to 0 to make sure it doesn't use the wrong offs=
et
> > >>>> when the register assumes default values again.
> > >>>>
> > >>>> To avoid the if-check in hdp_flush (which is more frequent), anoth=
er way
> > >>>> is to initialize the remap offset to default offset during early i=
nit
> > >>>> and hw fini/suspend sequences. It won't be obvious (even with this
> > >>>> patch) as to when remap offset vs default offset is used though.
> > >>>
> > >>> On resume, the common IP is resumed first so it will always be set.
> > >>> The only case that is a problem is init because we init GMC out of
> > >>> order.  We could init common before GMC in amdgpu_device_ip_init().=
  I
> > >>> think that should be fine, but I wasn't sure if there might be some
> > >>> fallout from that on certain cards.
> > >>>
> > >>
> > >> There are other places where an IP order is forced like in
> > >> amdgpu_device_ip_reinit_early_sriov(). This also may not affect this
> > >> case as remapping is not done for VF.
> > >>
> > >> Agree that a better way is to have the common IP to be inited first.
> > >
> > > How about these patches?
> > >
> >
> > Looks good to me. BTW, is nbio 7.7 for an APU (in which case hdp flush
> > is not expected to be used)?
>
> It would be used in some cases, e.g., GPU VM passthrough where we use
> the BAR rather than the carve out.
>
> Alex
>
>
> >
> > Thanks,
> > Lijo
> >
> > > Alex
> > >
> > >
> > >>
> > >> Thanks,
> > >> Lijo
> > >>
> > >>> Alex
> > >>>
> > >>>>
> > >>>> Thanks,
> > >>>> Lijo
> > >>>>
> > >>>>> Alex
> > >>>>>
> > >>>>>> ---
> > >>>>>> v2:
> > >>>>>>            Take care of IP resume cases (Alex Deucher)
> > >>>>>>            Add NULL check to nbio.funcs to cover older (GFXv8) A=
SICs (Felix Kuehling)
> > >>>>>>            Add more details in commit message and associate with=
 AER patch (Bjorn
> > >>>>>> Helgaas)
> > >>>>>>
> > >>>>>>     drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++=
++++++++++
> > >>>>>>     drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
> > >>>>>>     drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
> > >>>>>>     drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
> > >>>>>>     4 files changed, 24 insertions(+), 18 deletions(-)
> > >>>>>>
> > >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/driver=
s/gpu/drm/amd/amdgpu/amdgpu_device.c
> > >>>>>> index ce7d117efdb5..e420118769a5 100644
> > >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> > >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> > >>>>>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(=
struct amdgpu_device *adev)
> > >>>>>>            return 0;
> > >>>>>>     }
> > >>>>>>
> > >>>>>> +/**
> > >>>>>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initiali=
zation
> > >>>>>> + *
> > >>>>>> + * @adev: amdgpu_device pointer
> > >>>>>> + *
> > >>>>>> + * Any common hardware initialization sequence that needs to be=
 done before
> > >>>>>> + * hw init of individual IPs is performed here. This is differe=
nt from the
> > >>>>>> + * 'common block' which initializes a set of IPs.
> > >>>>>> + */
> > >>>>>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev=
)
> > >>>>>> +{
> > >>>>>> +       /* Remap HDP registers to a hole in mmio space, for the =
purpose
> > >>>>>> +        * of exposing those registers to process space. This ne=
eds to be
> > >>>>>> +        * done before hw init of ip blocks to take care of HDP =
flush
> > >>>>>> +        * operations through registers during hw_init.
> > >>>>>> +        */
> > >>>>>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_regi=
sters &&
> > >>>>>> +           !amdgpu_sriov_vf(adev))
> > >>>>>> +               adev->nbio.funcs->remap_hdp_registers(adev);
> > >>>>>> +}
> > >>>>>>
> > >>>>>>     /**
> > >>>>>>      * amdgpu_device_ip_init - run init for hardware IPs
> > >>>>>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct am=
dgpu_device *adev)
> > >>>>>>                                    DRM_ERROR("amdgpu_vram_scratc=
h_init failed %d\n", r);
> > >>>>>>                                    goto init_failed;
> > >>>>>>                            }
> > >>>>>> +
> > >>>>>> +                       amdgpu_device_prepare_ip(adev);
> > >>>>>>                            r =3D adev->ip_blocks[i].version->fun=
cs->hw_init((void *)adev);
> > >>>>>>                            if (r) {
> > >>>>>>                                    DRM_ERROR("hw_init %d failed =
%d\n", i, r);
> > >>>>>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_s=
riov(struct amdgpu_device *adev)
> > >>>>>>                    AMD_IP_BLOCK_TYPE_IH,
> > >>>>>>            };
> > >>>>>>
> > >>>>>> +       amdgpu_device_prepare_ip(adev);
> > >>>>>>            for (i =3D 0; i < adev->num_ip_blocks; i++) {
> > >>>>>>                    int j;
> > >>>>>>                    struct amdgpu_ip_block *block;
> > >>>>>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(=
struct amdgpu_device *adev)
> > >>>>>>     {
> > >>>>>>            int i, r;
> > >>>>>>
> > >>>>>> +       amdgpu_device_prepare_ip(adev);
> > >>>>>>            for (i =3D 0; i < adev->num_ip_blocks; i++) {
> > >>>>>>                    if (!adev->ip_blocks[i].status.valid || adev-=
>ip_blocks[i].status.hw)
> > >>>>>>                            continue;
> > >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/a=
md/amdgpu/nv.c
> > >>>>>> index b3fba8dea63c..3ac7fef74277 100644
> > >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
> > >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
> > >>>>>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle=
)
> > >>>>>>            nv_program_aspm(adev);
> > >>>>>>            /* setup nbio registers */
> > >>>>>>            adev->nbio.funcs->init_registers(adev);
> > >>>>>> -       /* remap HDP registers to a hole in mmio space,
> > >>>>>> -        * for the purpose of expose those registers
> > >>>>>> -        * to process space
> > >>>>>> -        */
> > >>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sri=
ov_vf(adev))
> > >>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> > >>>>>>            /* enable the doorbell aperture */
> > >>>>>>            nv_enable_doorbell_aperture(adev, true);
> > >>>>>>
> > >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/dr=
m/amd/amdgpu/soc15.c
> > >>>>>> index fde6154f2009..a0481e37d7cf 100644
> > >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> > >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> > >>>>>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *han=
dle)
> > >>>>>>            soc15_program_aspm(adev);
> > >>>>>>            /* setup nbio registers */
> > >>>>>>            adev->nbio.funcs->init_registers(adev);
> > >>>>>> -       /* remap HDP registers to a hole in mmio space,
> > >>>>>> -        * for the purpose of expose those registers
> > >>>>>> -        * to process space
> > >>>>>> -        */
> > >>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sri=
ov_vf(adev))
> > >>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> > >>>>>>
> > >>>>>>            /* enable the doorbell aperture */
> > >>>>>>            soc15_enable_doorbell_aperture(adev, true);
> > >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/dr=
m/amd/amdgpu/soc21.c
> > >>>>>> index 55284b24f113..16b447055102 100644
> > >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
> > >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
> > >>>>>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handl=
e)
> > >>>>>>            soc21_program_aspm(adev);
> > >>>>>>            /* setup nbio registers */
> > >>>>>>            adev->nbio.funcs->init_registers(adev);
> > >>>>>> -       /* remap HDP registers to a hole in mmio space,
> > >>>>>> -        * for the purpose of expose those registers
> > >>>>>> -        * to process space
> > >>>>>> -        */
> > >>>>>> -       if (adev->nbio.funcs->remap_hdp_registers)
> > >>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> > >>>>>>            /* enable the doorbell aperture */
> > >>>>>>            soc21_enable_doorbell_aperture(adev, true);
> > >>>>>>
> > >>>>>> --
> > >>>>>> 2.25.1
> > >>>>>>

--000000000000007a7405e7a2c51e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-drm-amdgpu-init-HDP-remap-as-part-of-GMC-hw_init-for.patch"
Content-Disposition: attachment; 
	filename="0001-drm-amdgpu-init-HDP-remap-as-part-of-GMC-hw_init-for.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7jgaj6b2>
X-Attachment-Id: f_l7jgaj6b2

RnJvbSBiYTcxZmIxYjc4MzQwYTkxNDY4ZmFiNDQwMDhhZjI0Y2E1NDhmMzhkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFRodSwgMSBTZXAgMjAyMiAxNTozMjoxNyAtMDQwMApTdWJqZWN0OiBbUEFUQ0gg
MS8zXSBkcm0vYW1kZ3B1OiBpbml0IEhEUCByZW1hcCBhcyBwYXJ0IG9mIEdNQyBod19pbml0IGZv
cgogZ21jOSwgMTAKCkdNQyBpcyB0aGUgcHJpbWFyeSB1c2VyIG9mIHRoaXMgc28gZG8gaXQgYXMg
cGFydCBvZiBHTUMgaW5pdApyYXRoZXIgdGhhbiBjb21tb24gaW5pdC4gVGhpcyB3YXkgdGhlIHJl
bWFwIGlzIGFsd2F5cyBhcHBsaWVkCmJlZm9yZSBpdCdzIHVzZWQuCgpUaGlzIGZpeGVzIHRoZSBV
bnN1cHBvcnRlZCBSZXF1ZXN0IGVycm9yIHJlcG9ydGVkIHRocm91Z2gKQUVSIGR1cmluZyBkcml2
ZXIgbG9hZC4gVGhlIGVycm9yIGhhcHBlbnMgYXMgYSB3cml0ZSBoYXBwZW5zCnRvIHRoZSByZW1h
cCBvZmZzZXQgYmVmb3JlIHJlYWwgcmVtYXBwaW5nIGlzIGRvbmUuCgpMaW5rOiBodHRwczovL2J1
Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNjM3MwoKVGhlIGVycm9yIHdhcyB1
bm5vdGljZWQgYmVmb3JlIGFuZCBnb3QgdmlzaWJsZSBiZWNhdXNlIG9mIHRoZSBjb21taXQKcmVm
ZXJlbmNlZCBiZWxvdy4gVGhpcyBkb2Vzbid0IGZpeCBhbnl0aGluZyBpbiB0aGUgY29tbWl0IGJl
bG93LCByYXRoZXIKZml4ZXMgdGhlIGlzc3VlIGluIGFtZGdwdSBleHBvc2VkIGJ5IHRoZSBjb21t
aXQuIFRoZSByZWZlcmVuY2UgaXMgb25seQp0byBhc3NvY2lhdGUgdGhpcyBjb21taXQgd2l0aCBi
ZWxvdyBvbmUgc28gdGhhdCBib3RoIGdvIHRvZ2V0aGVyLgoKRml4ZXM6IDg3OTVlMTgyYjAyZCAo
IlBDSS9wb3J0ZHJ2OiBEb24ndCBkaXNhYmxlIEFFUiByZXBvcnRpbmcgaW4gZ2V0X3BvcnRfZGV2
aWNlX2NhcGFiaWxpdHkoKSIpCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRl
ci5kZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvZ21jX3Yx
MF8wLmMgfCA3ICsrKysrKysKIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2dtY192OV8wLmMg
IHwgNyArKysrKysrCiBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9udi5jICAgICAgICB8IDYg
LS0tLS0tCiBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9zb2MxNS5jICAgICB8IDcgLS0tLS0t
LQogNCBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9nbWNfdjEwXzAuYyBiL2RyaXZl
cnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2dtY192MTBfMC5jCmluZGV4IGY1MTNlMmMyZTk2NC4uNmYx
Njg1MmVhN2M2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9nbWNfdjEw
XzAuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9nbWNfdjEwXzAuYwpAQCAtMTEw
MSw2ICsxMTAxLDEzIEBAIHN0YXRpYyBpbnQgZ21jX3YxMF8wX2h3X2luaXQodm9pZCAqaGFuZGxl
KQogCWlmIChhZGV2LT5nZnhodWIuZnVuY3MgJiYgYWRldi0+Z2Z4aHViLmZ1bmNzLT51dGNsMl9o
YXJ2ZXN0KQogCQlhZGV2LT5nZnhodWIuZnVuY3MtPnV0Y2wyX2hhcnZlc3QoYWRldik7CiAKKwkv
KiByZW1hcCBIRFAgcmVnaXN0ZXJzIHRvIGEgaG9sZSBpbiBtbWlvIHNwYWNlLAorCSAqIGZvciB0
aGUgcHVycG9zZSBvZiBleHBvc2UgdGhvc2UgcmVnaXN0ZXJzCisJICogdG8gcHJvY2VzcyBzcGFj
ZQorCSAqLworCWlmIChhZGV2LT5uYmlvLmZ1bmNzLT5yZW1hcF9oZHBfcmVnaXN0ZXJzKQorCQlh
ZGV2LT5uYmlvLmZ1bmNzLT5yZW1hcF9oZHBfcmVnaXN0ZXJzKGFkZXYpOworCiAJciA9IGdtY192
MTBfMF9nYXJ0X2VuYWJsZShhZGV2KTsKIAlpZiAocikKIAkJcmV0dXJuIHI7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9nbWNfdjlfMC5jIGIvZHJpdmVycy9ncHUvZHJt
L2FtZC9hbWRncHUvZ21jX3Y5XzAuYwppbmRleCA0NjAzNjUzOTE2ZjUuLjMxZTllODE1OWFiYSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvZ21jX3Y5XzAuYworKysgYi9k
cml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9nbWNfdjlfMC5jCkBAIC0xODMyLDYgKzE4MzIsMTMg
QEAgc3RhdGljIGludCBnbWNfdjlfMF9od19pbml0KHZvaWQgKmhhbmRsZSkKIAlpZiAoYWRldi0+
bW1odWIuZnVuY3MtPnVwZGF0ZV9wb3dlcl9nYXRpbmcpCiAJCWFkZXYtPm1taHViLmZ1bmNzLT51
cGRhdGVfcG93ZXJfZ2F0aW5nKGFkZXYsIHRydWUpOwogCisJLyogcmVtYXAgSERQIHJlZ2lzdGVy
cyB0byBhIGhvbGUgaW4gbW1pbyBzcGFjZSwKKwkgKiBmb3IgdGhlIHB1cnBvc2Ugb2YgZXhwb3Nl
IHRob3NlIHJlZ2lzdGVycworCSAqIHRvIHByb2Nlc3Mgc3BhY2UKKwkgKi8KKwlpZiAoYWRldi0+
bmJpby5mdW5jcy0+cmVtYXBfaGRwX3JlZ2lzdGVycykKKwkJYWRldi0+bmJpby5mdW5jcy0+cmVt
YXBfaGRwX3JlZ2lzdGVycyhhZGV2KTsKKwogCWFkZXYtPmhkcC5mdW5jcy0+aW5pdF9yZWdpc3Rl
cnMoYWRldik7CiAKIAkvKiBBZnRlciBIRFAgaXMgaW5pdGlhbGl6ZWQsIGZsdXNoIEhEUC4qLwpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbnYuYyBiL2RyaXZlcnMvZ3B1
L2RybS9hbWQvYW1kZ3B1L252LmMKaW5kZXggYTIzMzljYmVkZDMyLi5iOTdjN2NjNzIzNDkgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L252LmMKKysrIGIvZHJpdmVycy9n
cHUvZHJtL2FtZC9hbWRncHUvbnYuYwpAQCAtMTAyNywxMiArMTAyNyw2IEBAIHN0YXRpYyBpbnQg
bnZfY29tbW9uX2h3X2luaXQodm9pZCAqaGFuZGxlKQogCW52X3Byb2dyYW1fYXNwbShhZGV2KTsK
IAkvKiBzZXR1cCBuYmlvIHJlZ2lzdGVycyAqLwogCWFkZXYtPm5iaW8uZnVuY3MtPmluaXRfcmVn
aXN0ZXJzKGFkZXYpOwotCS8qIHJlbWFwIEhEUCByZWdpc3RlcnMgdG8gYSBob2xlIGluIG1taW8g
c3BhY2UsCi0JICogZm9yIHRoZSBwdXJwb3NlIG9mIGV4cG9zZSB0aG9zZSByZWdpc3RlcnMKLQkg
KiB0byBwcm9jZXNzIHNwYWNlCi0JICovCi0JaWYgKGFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hk
cF9yZWdpc3RlcnMpCi0JCWFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3RlcnMoYWRl
dik7CiAJLyogZW5hYmxlIHRoZSBkb29yYmVsbCBhcGVydHVyZSAqLwogCW52X2VuYWJsZV9kb29y
YmVsbF9hcGVydHVyZShhZGV2LCB0cnVlKTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJt
L2FtZC9hbWRncHUvc29jMTUuYyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L3NvYzE1LmMK
aW5kZXggNjAzYjAxZGI2OWUyLi5iMWQ4ZTY3NjdkNDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1
L2RybS9hbWQvYW1kZ3B1L3NvYzE1LmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
c29jMTUuYwpAQCAtMTIzNSwxMyArMTIzNSw2IEBAIHN0YXRpYyBpbnQgc29jMTVfY29tbW9uX2h3
X2luaXQodm9pZCAqaGFuZGxlKQogCXNvYzE1X3Byb2dyYW1fYXNwbShhZGV2KTsKIAkvKiBzZXR1
cCBuYmlvIHJlZ2lzdGVycyAqLwogCWFkZXYtPm5iaW8uZnVuY3MtPmluaXRfcmVnaXN0ZXJzKGFk
ZXYpOwotCS8qIHJlbWFwIEhEUCByZWdpc3RlcnMgdG8gYSBob2xlIGluIG1taW8gc3BhY2UsCi0J
ICogZm9yIHRoZSBwdXJwb3NlIG9mIGV4cG9zZSB0aG9zZSByZWdpc3RlcnMKLQkgKiB0byBwcm9j
ZXNzIHNwYWNlCi0JICovCi0JaWYgKGFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3Rl
cnMpCi0JCWFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3RlcnMoYWRldik7Ci0KIAkv
KiBlbmFibGUgdGhlIGRvb3JiZWxsIGFwZXJ0dXJlICovCiAJc29jMTVfZW5hYmxlX2Rvb3JiZWxs
X2FwZXJ0dXJlKGFkZXYsIHRydWUpOwogCS8qIEhXIGRvb3JiZWxsIHJvdXRpbmcgcG9saWN5OiBk
b29yYmVsbCB3cml0aW5nIG5vdAotLSAKMi4zNy4yCgo=
--000000000000007a7405e7a2c51e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0003-drm-amdgpu-add-HDP-remap-functionality-to-nbio-7.7.patch"
Content-Disposition: attachment; 
	filename="0003-drm-amdgpu-add-HDP-remap-functionality-to-nbio-7.7.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7jgaj630>
X-Attachment-Id: f_l7jgaj630

RnJvbSAyYjJmYTE0ODhiYTg5MzJjYjc2MDYzNDNjODFlMmM1OWI5ZDg2NjMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFR1ZSwgMzAgQXVnIDIwMjIgMTE6MDg6MDkgLTA0MDAKU3ViamVjdDogW1BBVENI
IDMvM10gZHJtL2FtZGdwdTogYWRkIEhEUCByZW1hcCBmdW5jdGlvbmFsaXR5IHRvIG5iaW8gNy43
CgpXYXMgbWlzc2luZyBiZWZvcmUgYW5kIHdvdWxkIGhhdmUgcmVzdWx0ZWQgaW4gYSB3cml0ZSB0
bwphIG5vbi1leGlzdGFudCByZWdpc3Rlci4gTm9ybWFsbHkgQVBVcyBkb24ndCB1c2UgSERQLCBi
dXQKb3RoZXIgYXNpY3MgY291bGQgdXNlIHRoaXMgY29kZSBhbmQgQVBVcyBkbyB1c2UgdGhlIEhE
UAp3aGVuIHVzZWQgaW4gcGFzc3Rocm91Z2guCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIg
PGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRn
cHUvbmJpb192N183LmMgfCA5ICsrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L25iaW9fdjdfNy5j
IGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192N183LmMKaW5kZXggMWRjOTVlZjIx
ZGE2Li4yMWVhYzA2YmYxZWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1
L25iaW9fdjdfNy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L25iaW9fdjdfNy5j
CkBAIC0yOCw2ICsyOCwxNCBAQAogI2luY2x1ZGUgIm5iaW8vbmJpb183XzdfMF9zaF9tYXNrLmgi
CiAjaW5jbHVkZSA8dWFwaS9saW51eC9rZmRfaW9jdGwuaD4KIAorc3RhdGljIHZvaWQgbmJpb192
N183X3JlbWFwX2hkcF9yZWdpc3RlcnMoc3RydWN0IGFtZGdwdV9kZXZpY2UgKmFkZXYpCit7CisJ
V1JFRzMyX1NPQzE1KE5CSU8sIDAsIHJlZ0JJRl9CWDBfUkVNQVBfSERQX01FTV9GTFVTSF9DTlRM
LAorCQkgICAgIGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZzZXQgKyBLRkRfTU1JT19SRU1BUF9I
RFBfTUVNX0ZMVVNIX0NOVEwpOworCVdSRUczMl9TT0MxNShOQklPLCAwLCByZWdCSUZfQlgwX1JF
TUFQX0hEUF9SRUdfRkxVU0hfQ05UTCwKKwkJICAgICBhZGV2LT5ybW1pb19yZW1hcC5yZWdfb2Zm
c2V0ICsgS0ZEX01NSU9fUkVNQVBfSERQX1JFR19GTFVTSF9DTlRMKTsKK30KKwogc3RhdGljIHUz
MiBuYmlvX3Y3XzdfZ2V0X3Jldl9pZChzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldikKIHsKIAl1
MzIgdG1wOwpAQCAtMzQyLDQgKzM1MCw1IEBAIGNvbnN0IHN0cnVjdCBhbWRncHVfbmJpb19mdW5j
cyBuYmlvX3Y3XzdfZnVuY3MgPSB7CiAJLmdldF9jbG9ja2dhdGluZ19zdGF0ZSA9IG5iaW9fdjdf
N19nZXRfY2xvY2tnYXRpbmdfc3RhdGUsCiAJLmloX2NvbnRyb2wgPSBuYmlvX3Y3XzdfaWhfY29u
dHJvbCwKIAkuaW5pdF9yZWdpc3RlcnMgPSBuYmlvX3Y3XzdfaW5pdF9yZWdpc3RlcnMsCisJLnJl
bWFwX2hkcF9yZWdpc3RlcnMgPSBuYmlvX3Y3XzdfcmVtYXBfaGRwX3JlZ2lzdGVycywKIH07Ci0t
IAoyLjM3LjIKCg==
--000000000000007a7405e7a2c51e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-drm-amdgpu-init-HDP-remap-as-part-of-GMC-hw_init-for.patch"
Content-Disposition: attachment; 
	filename="0002-drm-amdgpu-init-HDP-remap-as-part-of-GMC-hw_init-for.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7jgaj691>
X-Attachment-Id: f_l7jgaj691

RnJvbSAzMzk2YzRhNDVjMTZjZDE1OTNkOTBmNDBhNDU1ZWUzMDgxOGNiZjdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFRodSwgMSBTZXAgMjAyMiAxNTozNjoyOSAtMDQwMApTdWJqZWN0OiBbUEFUQ0gg
Mi8zXSBkcm0vYW1kZ3B1OiBpbml0IEhEUCByZW1hcCBhcyBwYXJ0IG9mIEdNQyBod19pbml0IGZv
cgogZ21jMTEKCkdNQyBpcyB0aGUgcHJpbWFyeSB1c2VyIG9mIHRoaXMgc28gZG8gaXQgYXMgcGFy
dCBvZiBHTUMgaW5pdApyYXRoZXIgdGhhbiBjb21tb24gaW5pdC4gVGhpcyB3YXkgdGhlIHJlbWFw
IGlzIGFsd2F5cyBhcHBsaWVkCmJlZm9yZSBpdCdzIHVzZWQuCgpUaGlzIGZpeGVzIHRoZSBVbnN1
cHBvcnRlZCBSZXF1ZXN0IGVycm9yIHJlcG9ydGVkIHRocm91Z2gKQUVSIGR1cmluZyBkcml2ZXIg
bG9hZC4gVGhlIGVycm9yIGhhcHBlbnMgYXMgYSB3cml0ZSBoYXBwZW5zCnRvIHRoZSByZW1hcCBv
ZmZzZXQgYmVmb3JlIHJlYWwgcmVtYXBwaW5nIGlzIGRvbmUuCgpMaW5rOiBodHRwczovL2J1Z3pp
bGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNjM3MwoKVGhlIGVycm9yIHdhcyB1bm5v
dGljZWQgYmVmb3JlIGFuZCBnb3QgdmlzaWJsZSBiZWNhdXNlIG9mIHRoZSBjb21taXQKcmVmZXJl
bmNlZCBiZWxvdy4gVGhpcyBkb2Vzbid0IGZpeCBhbnl0aGluZyBpbiB0aGUgY29tbWl0IGJlbG93
LCByYXRoZXIKZml4ZXMgdGhlIGlzc3VlIGluIGFtZGdwdSBleHBvc2VkIGJ5IHRoZSBjb21taXQu
IFRoZSByZWZlcmVuY2UgaXMgb25seQp0byBhc3NvY2lhdGUgdGhpcyBjb21taXQgd2l0aCBiZWxv
dyBvbmUgc28gdGhhdCBib3RoIGdvIHRvZ2V0aGVyLgoKRml4ZXM6IDg3OTVlMTgyYjAyZCAoIlBD
SS9wb3J0ZHJ2OiBEb24ndCBkaXNhYmxlIEFFUiByZXBvcnRpbmcgaW4gZ2V0X3BvcnRfZGV2aWNl
X2NhcGFiaWxpdHkoKSIpCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5k
ZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvZ21jX3YxMV8w
LmMgfCA3ICsrKysrKysKIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L3NvYzIxLmMgICAgIHwg
NiAtLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2dtY192MTFfMC5jIGIv
ZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvZ21jX3YxMV8wLmMKaW5kZXggODQ2Y2NiNmNmMDdk
Li5hZTkwN2JiZTcwZDcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2dt
Y192MTFfMC5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2dtY192MTFfMC5jCkBA
IC04OTQsNiArODk0LDEzIEBAIHN0YXRpYyBpbnQgZ21jX3YxMV8wX2h3X2luaXQodm9pZCAqaGFu
ZGxlKQogCS8qIFRoZSBzZXF1ZW5jZSBvZiB0aGVzZSB0d28gZnVuY3Rpb24gY2FsbHMgbWF0dGVy
cy4qLwogCWdtY192MTFfMF9pbml0X2dvbGRlbl9yZWdpc3RlcnMoYWRldik7CiAKKwkvKiByZW1h
cCBIRFAgcmVnaXN0ZXJzIHRvIGEgaG9sZSBpbiBtbWlvIHNwYWNlLAorCSAqIGZvciB0aGUgcHVy
cG9zZSBvZiBleHBvc2UgdGhvc2UgcmVnaXN0ZXJzCisJICogdG8gcHJvY2VzcyBzcGFjZQorCSAq
LworCWlmIChhZGV2LT5uYmlvLmZ1bmNzLT5yZW1hcF9oZHBfcmVnaXN0ZXJzKQorCQlhZGV2LT5u
YmlvLmZ1bmNzLT5yZW1hcF9oZHBfcmVnaXN0ZXJzKGFkZXYpOworCiAJciA9IGdtY192MTFfMF9n
YXJ0X2VuYWJsZShhZGV2KTsKIAlpZiAocikKIAkJcmV0dXJuIHI7CmRpZmYgLS1naXQgYS9kcml2
ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9zb2MyMS5jIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRn
cHUvc29jMjEuYwppbmRleCBhOWQ1YTc4NGNjNDguLjY0OGNkMWQ2NGZkNyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvc29jMjEuYworKysgYi9kcml2ZXJzL2dwdS9kcm0v
YW1kL2FtZGdwdS9zb2MyMS5jCkBAIC02NzQsMTIgKzY3NCw2IEBAIHN0YXRpYyBpbnQgc29jMjFf
Y29tbW9uX2h3X2luaXQodm9pZCAqaGFuZGxlKQogCXNvYzIxX3Byb2dyYW1fYXNwbShhZGV2KTsK
IAkvKiBzZXR1cCBuYmlvIHJlZ2lzdGVycyAqLwogCWFkZXYtPm5iaW8uZnVuY3MtPmluaXRfcmVn
aXN0ZXJzKGFkZXYpOwotCS8qIHJlbWFwIEhEUCByZWdpc3RlcnMgdG8gYSBob2xlIGluIG1taW8g
c3BhY2UsCi0JICogZm9yIHRoZSBwdXJwb3NlIG9mIGV4cG9zZSB0aG9zZSByZWdpc3RlcnMKLQkg
KiB0byBwcm9jZXNzIHNwYWNlCi0JICovCi0JaWYgKGFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hk
cF9yZWdpc3RlcnMpCi0JCWFkZXYtPm5iaW8uZnVuY3MtPnJlbWFwX2hkcF9yZWdpc3RlcnMoYWRl
dik7CiAJLyogZW5hYmxlIHRoZSBkb29yYmVsbCBhcGVydHVyZSAqLwogCXNvYzIxX2VuYWJsZV9k
b29yYmVsbF9hcGVydHVyZShhZGV2LCB0cnVlKTsKIAotLSAKMi4zNy4yCgo=
--000000000000007a7405e7a2c51e--
