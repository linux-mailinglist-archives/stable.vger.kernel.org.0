Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C4D5A66F0
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 17:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiH3PKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 11:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiH3PKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 11:10:00 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8216111467
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:09:57 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id t8-20020a9d5908000000b0063b41908168so202533oth.8
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JWHgLC3uSQFJpNjKUUSH9vjcsG7fVOSzXeSj+vKKmuk=;
        b=GQzF7apqoREhn/uNoDYD7pC1swaq8QcdM5oFRcbZ5YP2TsmlE0yh/0FzdHmXXBPXBw
         QSv9tOJ6qVbEtm/5YwcZSnrDkxs7CLBCBeviPirhk0212UumtxX1qrOwS79ofFuIcIIt
         WgaGw7GMC9aQ1TbFzIkG+AyPgcHQ4jBYApav6mz0QoI4/OJxszKs+w4c1+Be+/CcwNAI
         KXoPSG3F3KcQOpAokTwT+i858AqjSci/LYOZoqxFtUP5KH3yguviBAOYuETPBeuzTvlC
         Hyf8EtL0MbAUtc23TDOZsGOAmO6Tse668MGpd41Dh1CjLeok2VoKURcUKHMODlWdjOI1
         7LHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JWHgLC3uSQFJpNjKUUSH9vjcsG7fVOSzXeSj+vKKmuk=;
        b=FxqNa3kiHs8B4Q8MXh2uaWVSVZNowL8yOLQcqXX9zg1+8nK+ld8ICnG9SbKPbA+uP4
         Ad0ZgSIVLK71HDonHRKpqWTKYFRMhvVkmPwktAVsG/97s/TWAwLP0035C/amBadzLNF9
         4RgUOM1hCfZC94+WsZK9OmNkfCr2QJXqauJa+PVxZLSa8nw+v55Tk5h0HjdbeB69yCWA
         1RsPHhtPwvGlBqiNNAxx78QzxfDQZWo9D3vi/xvvXYxG5CWZwP0elJfAhjKH35hsnf3F
         a+3KudI3WjqUEbywn+187NBvSzA6C0YF18HkcRt6aIPHeWNO0FOwbduDUhdIIQdnb1hH
         XCwg==
X-Gm-Message-State: ACgBeo1UIYGICkUhUFaeAwfYawOnFAjA1pWyUqNRK/IPsGf81sVcWwzg
        TlgBNB+HeUPNRM/9WQcYeFnSb/uor0iAMWamNZEE92kZ
X-Google-Smtp-Source: AA6agR6dZXSs7cdkSD6r4/zLz8P2D9h+42/bYCaIB8XWVKpLhHjeKZKV3w6UspJ3E45uPPLj2HPD1Eup9DaZT+nweys=
X-Received: by 2002:a9d:6ad7:0:b0:636:f76b:638a with SMTP id
 m23-20020a9d6ad7000000b00636f76b638amr8911683otq.233.1661872197108; Tue, 30
 Aug 2022 08:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220829081752.1258274-1-lijo.lazar@amd.com> <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
 <3b2a9a8f-dedf-2781-0023-d6bd64f16d65@amd.com> <CADnq5_P0=+NNk2v_VOxyjOVSnY55SY=OX40xD5Bx6etspREnfA@mail.gmail.com>
 <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com>
In-Reply-To: <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 30 Aug 2022 11:09:45 -0400
Message-ID: <CADnq5_Pkpe_-SH8Wh=_s6FXDFEWvO8rr5Ls2=Q4HRXy9+eSOBQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm/amdgpu: Move HDP remapping earlier during init
To:     "Lazar, Lijo" <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Felix.Kuehling@amd.com,
        stable@vger.kernel.org, tseewald@gmail.com, helgaas@kernel.org,
        Alexander.Deucher@amd.com, sr@denx.de, Christian.Koenig@amd.com,
        Hawking.Zhang@amd.com
Content-Type: multipart/mixed; boundary="000000000000f8db7c05e776c57b"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000f8db7c05e776c57b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2022 at 10:45 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>
>
>
> On 8/30/2022 7:18 PM, Alex Deucher wrote:
> > On Tue, Aug 30, 2022 at 12:05 AM Lazar, Lijo <lijo.lazar@amd.com> wrote=
:
> >>
> >>
> >>
> >> On 8/29/2022 10:20 PM, Alex Deucher wrote:
> >>> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wrote=
:
> >>>>
> >>>> HDP flush is used early in the init sequence as part of memory contr=
oller
> >>>> block initialization. Hence remapping of HDP registers needed for fl=
ush
> >>>> needs to happen earlier.
> >>>>
> >>>> This also fixes the Unsupported Request error reported through AER d=
uring
> >>>> driver load. The error happens as a write happens to the remap offse=
t
> >>>> before real remapping is done.
> >>>>
> >>>> Link: https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A=
%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=3D05%7C01%7=
Clijo.lazar%40amd.com%7C66066549213c45b1341508da8a8e4f1b%7C3dd8961fe4884e60=
8e11a82d994e183d%7C0%7C0%7C637974641082680316%7CUnknown%7CTWFpbGZsb3d8eyJWI=
joiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%=
7C&amp;sdata=3Dti%2FktO6Gmrio3TLDoteeJil28PY3D%2BLAinB6TU2mI9s%3D&amp;reser=
ved=3D0
> >>>>
> >>>> The error was unnoticed before and got visible because of the commit
> >>>> referenced below. This doesn't fix anything in the commit below, rat=
her
> >>>> fixes the issue in amdgpu exposed by the commit. The reference is on=
ly
> >>>> to associate this commit with below one so that both go together.
> >>>>
> >>>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in ge=
t_port_device_capability()")
> >>>>
> >>>> Reported-by: Tom Seewald <tseewald@gmail.com>
> >>>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> >>>> Cc: stable@vger.kernel.org
> >>>
> >>> How about something like the attached patch rather than these two
> >>> patches?  It's a bit bigger but seems cleaner and more defensive in m=
y
> >>> opinion.
> >>>
> >>
> >> Whenever device goes to suspend/reset and then comes back, remap offse=
t
> >> has to be set back to 0 to make sure it doesn't use the wrong offset
> >> when the register assumes default values again.
> >>
> >> To avoid the if-check in hdp_flush (which is more frequent), another w=
ay
> >> is to initialize the remap offset to default offset during early init
> >> and hw fini/suspend sequences. It won't be obvious (even with this
> >> patch) as to when remap offset vs default offset is used though.
> >
> > On resume, the common IP is resumed first so it will always be set.
> > The only case that is a problem is init because we init GMC out of
> > order.  We could init common before GMC in amdgpu_device_ip_init().  I
> > think that should be fine, but I wasn't sure if there might be some
> > fallout from that on certain cards.
> >
>
> There are other places where an IP order is forced like in
> amdgpu_device_ip_reinit_early_sriov(). This also may not affect this
> case as remapping is not done for VF.
>
> Agree that a better way is to have the common IP to be inited first.

How about these patches?

Alex


>
> Thanks,
> Lijo
>
> > Alex
> >
> >>
> >> Thanks,
> >> Lijo
> >>
> >>> Alex
> >>>
> >>>> ---
> >>>> v2:
> >>>>           Take care of IP resume cases (Alex Deucher)
> >>>>           Add NULL check to nbio.funcs to cover older (GFXv8) ASICs =
(Felix Kuehling)
> >>>>           Add more details in commit message and associate with AER =
patch (Bjorn
> >>>> Helgaas)
> >>>>
> >>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 +++++++++++++++++=
+++++
> >>>>    drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
> >>>>    drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
> >>>>    drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
> >>>>    4 files changed, 24 insertions(+), 18 deletions(-)
> >>>>
> >>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gp=
u/drm/amd/amdgpu/amdgpu_device.c
> >>>> index ce7d117efdb5..e420118769a5 100644
> >>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> >>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> >>>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(stru=
ct amdgpu_device *adev)
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> +/**
> >>>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initializati=
on
> >>>> + *
> >>>> + * @adev: amdgpu_device pointer
> >>>> + *
> >>>> + * Any common hardware initialization sequence that needs to be don=
e before
> >>>> + * hw init of individual IPs is performed here. This is different f=
rom the
> >>>> + * 'common block' which initializes a set of IPs.
> >>>> + */
> >>>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
> >>>> +{
> >>>> +       /* Remap HDP registers to a hole in mmio space, for the purp=
ose
> >>>> +        * of exposing those registers to process space. This needs =
to be
> >>>> +        * done before hw init of ip blocks to take care of HDP flus=
h
> >>>> +        * operations through registers during hw_init.
> >>>> +        */
> >>>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_register=
s &&
> >>>> +           !amdgpu_sriov_vf(adev))
> >>>> +               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>> +}
> >>>>
> >>>>    /**
> >>>>     * amdgpu_device_ip_init - run init for hardware IPs
> >>>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdgpu=
_device *adev)
> >>>>                                   DRM_ERROR("amdgpu_vram_scratch_ini=
t failed %d\n", r);
> >>>>                                   goto init_failed;
> >>>>                           }
> >>>> +
> >>>> +                       amdgpu_device_prepare_ip(adev);
> >>>>                           r =3D adev->ip_blocks[i].version->funcs->h=
w_init((void *)adev);
> >>>>                           if (r) {
> >>>>                                   DRM_ERROR("hw_init %d failed %d\n"=
, i, r);
> >>>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sriov=
(struct amdgpu_device *adev)
> >>>>                   AMD_IP_BLOCK_TYPE_IH,
> >>>>           };
> >>>>
> >>>> +       amdgpu_device_prepare_ip(adev);
> >>>>           for (i =3D 0; i < adev->num_ip_blocks; i++) {
> >>>>                   int j;
> >>>>                   struct amdgpu_ip_block *block;
> >>>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(stru=
ct amdgpu_device *adev)
> >>>>    {
> >>>>           int i, r;
> >>>>
> >>>> +       amdgpu_device_prepare_ip(adev);
> >>>>           for (i =3D 0; i < adev->num_ip_blocks; i++) {
> >>>>                   if (!adev->ip_blocks[i].status.valid || adev->ip_b=
locks[i].status.hw)
> >>>>                           continue;
> >>>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/a=
mdgpu/nv.c
> >>>> index b3fba8dea63c..3ac7fef74277 100644
> >>>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
> >>>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
> >>>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
> >>>>           nv_program_aspm(adev);
> >>>>           /* setup nbio registers */
> >>>>           adev->nbio.funcs->init_registers(adev);
> >>>> -       /* remap HDP registers to a hole in mmio space,
> >>>> -        * for the purpose of expose those registers
> >>>> -        * to process space
> >>>> -        */
> >>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_v=
f(adev))
> >>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>>           /* enable the doorbell aperture */
> >>>>           nv_enable_doorbell_aperture(adev, true);
> >>>>
> >>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/am=
d/amdgpu/soc15.c
> >>>> index fde6154f2009..a0481e37d7cf 100644
> >>>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> >>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> >>>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handle)
> >>>>           soc15_program_aspm(adev);
> >>>>           /* setup nbio registers */
> >>>>           adev->nbio.funcs->init_registers(adev);
> >>>> -       /* remap HDP registers to a hole in mmio space,
> >>>> -        * for the purpose of expose those registers
> >>>> -        * to process space
> >>>> -        */
> >>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_v=
f(adev))
> >>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>>
> >>>>           /* enable the doorbell aperture */
> >>>>           soc15_enable_doorbell_aperture(adev, true);
> >>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/am=
d/amdgpu/soc21.c
> >>>> index 55284b24f113..16b447055102 100644
> >>>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
> >>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
> >>>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
> >>>>           soc21_program_aspm(adev);
> >>>>           /* setup nbio registers */
> >>>>           adev->nbio.funcs->init_registers(adev);
> >>>> -       /* remap HDP registers to a hole in mmio space,
> >>>> -        * for the purpose of expose those registers
> >>>> -        * to process space
> >>>> -        */
> >>>> -       if (adev->nbio.funcs->remap_hdp_registers)
> >>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>>           /* enable the doorbell aperture */
> >>>>           soc21_enable_doorbell_aperture(adev, true);
> >>>>
> >>>> --
> >>>> 2.25.1
> >>>>

--000000000000f8db7c05e776c57b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-drm-amdgpu-add-HDP-remap-functionality-to-nbio-7.7.patch"
Content-Disposition: attachment; 
	filename="0002-drm-amdgpu-add-HDP-remap-functionality-to-nbio-7.7.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7gbsbp60>
X-Attachment-Id: f_l7gbsbp60

RnJvbSBkYjY1MjNmMjg0ZDlmMzU2YWRlOTYxZTRlNmE2NzFjNWEwNmU3N2Q3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFR1ZSwgMzAgQXVnIDIwMjIgMTE6MDg6MDkgLTA0MDAKU3ViamVjdDogW1BBVENI
IDIvMl0gZHJtL2FtZGdwdTogYWRkIEhEUCByZW1hcCBmdW5jdGlvbmFsaXR5IHRvIG5iaW8gNy43
CgpXYXMgbWlzc2luZyBiZWZvcmUgYW5kIHdvdWxkIGhhdmUgcmVzdWx0ZWQgaW4gYSB3cml0ZSB0
bwphIG5vbi1leGlzdGFudCByZWdpc3Rlci4KClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8
YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdw
dS9uYmlvX3Y3XzcuYyB8IDkgKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192N183LmMg
Yi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9uYmlvX3Y3XzcuYwppbmRleCAxZGM5NWVmMjFk
YTYuLjIxZWFjMDZiZjFlZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
bmJpb192N183LmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvbmJpb192N183LmMK
QEAgLTI4LDYgKzI4LDE0IEBACiAjaW5jbHVkZSAibmJpby9uYmlvXzdfN18wX3NoX21hc2suaCIK
ICNpbmNsdWRlIDx1YXBpL2xpbnV4L2tmZF9pb2N0bC5oPgogCitzdGF0aWMgdm9pZCBuYmlvX3Y3
XzdfcmVtYXBfaGRwX3JlZ2lzdGVycyhzdHJ1Y3QgYW1kZ3B1X2RldmljZSAqYWRldikKK3sKKwlX
UkVHMzJfU09DMTUoTkJJTywgMCwgcmVnQklGX0JYMF9SRU1BUF9IRFBfTUVNX0ZMVVNIX0NOVEws
CisJCSAgICAgYWRldi0+cm1taW9fcmVtYXAucmVnX29mZnNldCArIEtGRF9NTUlPX1JFTUFQX0hE
UF9NRU1fRkxVU0hfQ05UTCk7CisJV1JFRzMyX1NPQzE1KE5CSU8sIDAsIHJlZ0JJRl9CWDBfUkVN
QVBfSERQX1JFR19GTFVTSF9DTlRMLAorCQkgICAgIGFkZXYtPnJtbWlvX3JlbWFwLnJlZ19vZmZz
ZXQgKyBLRkRfTU1JT19SRU1BUF9IRFBfUkVHX0ZMVVNIX0NOVEwpOworfQorCiBzdGF0aWMgdTMy
IG5iaW9fdjdfN19nZXRfcmV2X2lkKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KQogewogCXUz
MiB0bXA7CkBAIC0zNDIsNCArMzUwLDUgQEAgY29uc3Qgc3RydWN0IGFtZGdwdV9uYmlvX2Z1bmNz
IG5iaW9fdjdfN19mdW5jcyA9IHsKIAkuZ2V0X2Nsb2NrZ2F0aW5nX3N0YXRlID0gbmJpb192N183
X2dldF9jbG9ja2dhdGluZ19zdGF0ZSwKIAkuaWhfY29udHJvbCA9IG5iaW9fdjdfN19paF9jb250
cm9sLAogCS5pbml0X3JlZ2lzdGVycyA9IG5iaW9fdjdfN19pbml0X3JlZ2lzdGVycywKKwkucmVt
YXBfaGRwX3JlZ2lzdGVycyA9IG5iaW9fdjdfN19yZW1hcF9oZHBfcmVnaXN0ZXJzLAogfTsKLS0g
CjIuMzcuMQoK
--000000000000f8db7c05e776c57b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-drm-amdgpu-make-sure-to-init-common-IP-before-gmc.patch"
Content-Disposition: attachment; 
	filename="0001-drm-amdgpu-make-sure-to-init-common-IP-before-gmc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7gbsbph1>
X-Attachment-Id: f_l7gbsbph1

RnJvbSBjMGRkNDkwNGFhYzNlZDY5ZWQ1YmExZjM1NGJmYzAzYzgxYzI3MjNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFR1ZSwgMzAgQXVnIDIwMjIgMTA6NTk6NDkgLTA0MDAKU3ViamVjdDogW1BBVENI
IDEvMl0gZHJtL2FtZGdwdTogbWFrZSBzdXJlIHRvIGluaXQgY29tbW9uIElQIGJlZm9yZSBnbWMK
CkNvbW1vbiBpcyBtYWlubHkgZ29sZGVuIHJlZ2lzdGVyIHNldHRpbmcgYW5kIEhEUCByZWdpc3Rl
cgpyZW1hcHBpbmcsIGl0IHNob3VsZG4ndCBhbGxvY2F0ZSBhbnkgR1BVIG1lbW9yeS4gIE1ha2Ug
c3VyZQpjb21tb24gaGFwcGVucyBiZWZvcmUgZ21jIHNvIHRoYXQgdGhlIEhEUCByZWdpc3RlcnMg
YXJlCnJlbWFwcGVkIGJlZm9yZSBnbWMgYXR0ZW1wdHMgdG8gYWNjZXNzIHRoZW0uCgpUaGlzIGZp
eGVzIHRoZSBVbnN1cHBvcnRlZCBSZXF1ZXN0IGVycm9yIHJlcG9ydGVkIHRocm91Z2gKQUVSIGR1
cmluZyBkcml2ZXIgbG9hZC4gVGhlIGVycm9yIGhhcHBlbnMgYXMgYSB3cml0ZSBoYXBwZW5zCnRv
IHRoZSByZW1hcCBvZmZzZXQgYmVmb3JlIHJlYWwgcmVtYXBwaW5nIGlzIGRvbmUuCgpMaW5rOiBo
dHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNjM3MwoKVGhlIGVy
cm9yIHdhcyB1bm5vdGljZWQgYmVmb3JlIGFuZCBnb3QgdmlzaWJsZSBiZWNhdXNlIG9mIHRoZSBj
b21taXQKcmVmZXJlbmNlZCBiZWxvdy4gVGhpcyBkb2Vzbid0IGZpeCBhbnl0aGluZyBpbiB0aGUg
Y29tbWl0IGJlbG93LCByYXRoZXIKZml4ZXMgdGhlIGlzc3VlIGluIGFtZGdwdSBleHBvc2VkIGJ5
IHRoZSBjb21taXQuIFRoZSByZWZlcmVuY2UgaXMgb25seQp0byBhc3NvY2lhdGUgdGhpcyBjb21t
aXQgd2l0aCBiZWxvdyBvbmUgc28gdGhhdCBib3RoIGdvIHRvZ2V0aGVyLgoKRml4ZXM6IDg3OTVl
MTgyYjAyZCAoIlBDSS9wb3J0ZHJ2OiBEb24ndCBkaXNhYmxlIEFFUiByZXBvcnRpbmcgaW4gZ2V0
X3BvcnRfZGV2aWNlX2NhcGFiaWxpdHkoKSIpCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIg
PGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRn
cHUvYW1kZ3B1X2RldmljZS5jIHwgMTQgKysrKysrKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAx
MSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9kZXZpY2UuYyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1k
Z3B1L2FtZGdwdV9kZXZpY2UuYwppbmRleCBkNjQyNDUzNWUzNDAuLjg4MzY0NWQ4MTAzMCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X2RldmljZS5jCisrKyBi
L2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9kZXZpY2UuYwpAQCAtMjM3NSw4ICsy
Mzc1LDE2IEBAIHN0YXRpYyBpbnQgYW1kZ3B1X2RldmljZV9pcF9pbml0KHN0cnVjdCBhbWRncHVf
ZGV2aWNlICphZGV2KQogCQl9CiAJCWFkZXYtPmlwX2Jsb2Nrc1tpXS5zdGF0dXMuc3cgPSB0cnVl
OwogCi0JCS8qIG5lZWQgdG8gZG8gZ21jIGh3IGluaXQgZWFybHkgc28gd2UgY2FuIGFsbG9jYXRl
IGdwdSBtZW0gKi8KLQkJaWYgKGFkZXYtPmlwX2Jsb2Nrc1tpXS52ZXJzaW9uLT50eXBlID09IEFN
RF9JUF9CTE9DS19UWVBFX0dNQykgeworCQlpZiAoYWRldi0+aXBfYmxvY2tzW2ldLnZlcnNpb24t
PnR5cGUgPT0gQU1EX0lQX0JMT0NLX1RZUEVfQ09NTU9OKSB7CisJCQkvKiBuZWVkIHRvIGRvIGNv
bW1vbiBodyBpbml0IGVhcmx5IHNvIGV2ZXJ5dGhpbmcgaXMgc2V0IHVwIGZvciBnbWMgKi8KKwkJ
CXIgPSBhZGV2LT5pcF9ibG9ja3NbaV0udmVyc2lvbi0+ZnVuY3MtPmh3X2luaXQoKHZvaWQgKilh
ZGV2KTsKKwkJCWlmIChyKSB7CisJCQkJRFJNX0VSUk9SKCJod19pbml0ICVkIGZhaWxlZCAlZFxu
IiwgaSwgcik7CisJCQkJZ290byBpbml0X2ZhaWxlZDsKKwkJCX0KKwkJCWFkZXYtPmlwX2Jsb2Nr
c1tpXS5zdGF0dXMuaHcgPSB0cnVlOworCQl9IGVsc2UgaWYgKGFkZXYtPmlwX2Jsb2Nrc1tpXS52
ZXJzaW9uLT50eXBlID09IEFNRF9JUF9CTE9DS19UWVBFX0dNQykgeworCQkJLyogbmVlZCB0byBk
byBnbWMgaHcgaW5pdCBlYXJseSBzbyB3ZSBjYW4gYWxsb2NhdGUgZ3B1IG1lbSAqLwogCQkJLyog
VHJ5IHRvIHJlc2VydmUgYmFkIHBhZ2VzIGVhcmx5ICovCiAJCQlpZiAoYW1kZ3B1X3NyaW92X3Zm
KGFkZXYpKQogCQkJCWFtZGdwdV92aXJ0X2V4Y2hhbmdlX2RhdGEoYWRldik7CkBAIC0zMDYyLDgg
KzMwNzAsOCBAQCBzdGF0aWMgaW50IGFtZGdwdV9kZXZpY2VfaXBfcmVpbml0X2Vhcmx5X3NyaW92
KHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KQogCWludCBpLCByOwogCiAJc3RhdGljIGVudW0g
YW1kX2lwX2Jsb2NrX3R5cGUgaXBfb3JkZXJbXSA9IHsKLQkJQU1EX0lQX0JMT0NLX1RZUEVfR01D
LAogCQlBTURfSVBfQkxPQ0tfVFlQRV9DT01NT04sCisJCUFNRF9JUF9CTE9DS19UWVBFX0dNQywK
IAkJQU1EX0lQX0JMT0NLX1RZUEVfUFNQLAogCQlBTURfSVBfQkxPQ0tfVFlQRV9JSCwKIAl9Owot
LSAKMi4zNy4xCgo=
--000000000000f8db7c05e776c57b--
