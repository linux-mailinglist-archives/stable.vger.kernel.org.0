Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D7D5A6BBB
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 20:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiH3SGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 14:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiH3SFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 14:05:49 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7721F632
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 11:05:47 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-11f11d932a8so10228178fac.3
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 11:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=F0ueCM60ir7/z3vaa7/6oFpmXX4wyDkZf5kv00q9Xb8=;
        b=pdT69P/gkn+7YC4HLszaRJzzB2tTpn5opkil5K+QYAlVeEhvaXzSjJtc6syzeJCo7q
         VwEyHn+cZVXcI3DmhLb1E47d2naq5G7QxcrD7xDXt3Tm2uJyjhzG+PuToY2vwapqzU4Q
         IAsk/TNMjJ9hnXX/QkFLS6cnQbYsJVP/Q1cyvIRv0kNbJjWnqzbPtnkzhAPZGP0H4imy
         hxl0gujrEoqiGvWQppWZHEiiYUBi/Nn96T17Q7aDAY+xQE/xvqeqkiSqFYYUJZQNwIac
         MQ+6lyKmcuJQ14KZ0wLHlybJg2SMhFCWxf8cVtUaUexcwHq1oVPkP9TNpjUokig9voUK
         dCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=F0ueCM60ir7/z3vaa7/6oFpmXX4wyDkZf5kv00q9Xb8=;
        b=SfvAjRJUJUhTVLJxNK1JQcSUIwuhMZAzlSWN6gJCxR8kQaa7jtwfvXPWPPhz1zm3LZ
         bkHqj4hhMHt/dCqu1+nbuLWBwze0z3GY65gKLgdprq8SzKMLm9dQbFZ2s15KLL1TZwOP
         +51PvsrM0e1RHqrxwurSKPpjuvlpiLb97IjjQWDSOFE+r03/XrFYAsZDlkGrmReqvLbb
         tBi+pFW7uM3yKQNJ9R82MdtabdvQLiQ0ysit4ccm+pi3uTdWVcGewwtQT01gr2IJx1D4
         pm9LmsHIfbNK0fCMXpcOpr5sWjkkjo+ocCi27qw1UTCgdMS6W2AICsTVSkgmBJVWMHbo
         2MSQ==
X-Gm-Message-State: ACgBeo344Lz3Tg3cNdBL35Xcauz7xL4mo2O5G9ESJFr6uDxeV2j220Sf
        9xh0Bwbv2JIAVeLowk9AlSBond1JWEJjIF1WqF4=
X-Google-Smtp-Source: AA6agR4Rlj7SZjCskh1IOQP9jxWC3m2h/i7vhtSx7e2p1fkwqs7sFz4IJvtjmJ2iSyfB/sZa6qi9HDMdnfz/ylLCsA0=
X-Received: by 2002:a05:6870:3484:b0:11e:4465:3d9b with SMTP id
 n4-20020a056870348400b0011e44653d9bmr11330039oah.46.1661882746925; Tue, 30
 Aug 2022 11:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220829081752.1258274-1-lijo.lazar@amd.com> <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
 <3b2a9a8f-dedf-2781-0023-d6bd64f16d65@amd.com> <CADnq5_P0=+NNk2v_VOxyjOVSnY55SY=OX40xD5Bx6etspREnfA@mail.gmail.com>
 <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com> <CADnq5_Pkpe_-SH8Wh=_s6FXDFEWvO8rr5Ls2=Q4HRXy9+eSOBQ@mail.gmail.com>
 <9ef0287a-e463-d440-58fe-0323a6eca94a@amd.com>
In-Reply-To: <9ef0287a-e463-d440-58fe-0323a6eca94a@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 30 Aug 2022 14:05:35 -0400
Message-ID: <CADnq5_P1VV2zWpjtsedPCoJH_CKv+d-MuVJwxOBbdpo1fLFCjA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm/amdgpu: Move HDP remapping earlier during init
To:     "Lazar, Lijo" <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Felix.Kuehling@amd.com,
        stable@vger.kernel.org, tseewald@gmail.com, helgaas@kernel.org,
        Alexander.Deucher@amd.com, sr@denx.de, Christian.Koenig@amd.com,
        Hawking.Zhang@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 12:06 PM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>
>
>
> On 8/30/2022 8:39 PM, Alex Deucher wrote:
> > On Tue, Aug 30, 2022 at 10:45 AM Lazar, Lijo <lijo.lazar@amd.com> wrote=
:
> >>
> >>
> >>
> >> On 8/30/2022 7:18 PM, Alex Deucher wrote:
> >>> On Tue, Aug 30, 2022 at 12:05 AM Lazar, Lijo <lijo.lazar@amd.com> wro=
te:
> >>>>
> >>>>
> >>>>
> >>>> On 8/29/2022 10:20 PM, Alex Deucher wrote:
> >>>>> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wro=
te:
> >>>>>>
> >>>>>> HDP flush is used early in the init sequence as part of memory con=
troller
> >>>>>> block initialization. Hence remapping of HDP registers needed for =
flush
> >>>>>> needs to happen earlier.
> >>>>>>
> >>>>>> This also fixes the Unsupported Request error reported through AER=
 during
> >>>>>> driver load. The error happens as a write happens to the remap off=
set
> >>>>>> before real remapping is done.
> >>>>>>
> >>>>>> Link: https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%=
3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=3D05%7C01=
%7Clijo.lazar%40amd.com%7Cbe8781fe1b0c41d3bad408da8a99b3d8%7C3dd8961fe4884e=
608e11a82d994e183d%7C0%7C0%7C637974690005710507%7CUnknown%7CTWFpbGZsb3d8eyJ=
WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7=
C%7C&amp;sdata=3D98WWFEcwi2tzyf%2BxnYC%2FK3UcCE5mfXI00qfYGUpt2Sk%3D&amp;res=
erved=3D0
> >>>>>>
> >>>>>> The error was unnoticed before and got visible because of the comm=
it
> >>>>>> referenced below. This doesn't fix anything in the commit below, r=
ather
> >>>>>> fixes the issue in amdgpu exposed by the commit. The reference is =
only
> >>>>>> to associate this commit with below one so that both go together.
> >>>>>>
> >>>>>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in =
get_port_device_capability()")
> >>>>>>
> >>>>>> Reported-by: Tom Seewald <tseewald@gmail.com>
> >>>>>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> >>>>>> Cc: stable@vger.kernel.org
> >>>>>
> >>>>> How about something like the attached patch rather than these two
> >>>>> patches?  It's a bit bigger but seems cleaner and more defensive in=
 my
> >>>>> opinion.
> >>>>>
> >>>>
> >>>> Whenever device goes to suspend/reset and then comes back, remap off=
set
> >>>> has to be set back to 0 to make sure it doesn't use the wrong offset
> >>>> when the register assumes default values again.
> >>>>
> >>>> To avoid the if-check in hdp_flush (which is more frequent), another=
 way
> >>>> is to initialize the remap offset to default offset during early ini=
t
> >>>> and hw fini/suspend sequences. It won't be obvious (even with this
> >>>> patch) as to when remap offset vs default offset is used though.
> >>>
> >>> On resume, the common IP is resumed first so it will always be set.
> >>> The only case that is a problem is init because we init GMC out of
> >>> order.  We could init common before GMC in amdgpu_device_ip_init().  =
I
> >>> think that should be fine, but I wasn't sure if there might be some
> >>> fallout from that on certain cards.
> >>>
> >>
> >> There are other places where an IP order is forced like in
> >> amdgpu_device_ip_reinit_early_sriov(). This also may not affect this
> >> case as remapping is not done for VF.
> >>
> >> Agree that a better way is to have the common IP to be inited first.
> >
> > How about these patches?
> >
>
> Looks good to me. BTW, is nbio 7.7 for an APU (in which case hdp flush
> is not expected to be used)?

It would be used in some cases, e.g., GPU VM passthrough where we use
the BAR rather than the carve out.

Alex


>
> Thanks,
> Lijo
>
> > Alex
> >
> >
> >>
> >> Thanks,
> >> Lijo
> >>
> >>> Alex
> >>>
> >>>>
> >>>> Thanks,
> >>>> Lijo
> >>>>
> >>>>> Alex
> >>>>>
> >>>>>> ---
> >>>>>> v2:
> >>>>>>            Take care of IP resume cases (Alex Deucher)
> >>>>>>            Add NULL check to nbio.funcs to cover older (GFXv8) ASI=
Cs (Felix Kuehling)
> >>>>>>            Add more details in commit message and associate with A=
ER patch (Bjorn
> >>>>>> Helgaas)
> >>>>>>
> >>>>>>     drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++++=
++++++++
> >>>>>>     drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
> >>>>>>     drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
> >>>>>>     drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
> >>>>>>     4 files changed, 24 insertions(+), 18 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/=
gpu/drm/amd/amdgpu/amdgpu_device.c
> >>>>>> index ce7d117efdb5..e420118769a5 100644
> >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> >>>>>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(st=
ruct amdgpu_device *adev)
> >>>>>>            return 0;
> >>>>>>     }
> >>>>>>
> >>>>>> +/**
> >>>>>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initializa=
tion
> >>>>>> + *
> >>>>>> + * @adev: amdgpu_device pointer
> >>>>>> + *
> >>>>>> + * Any common hardware initialization sequence that needs to be d=
one before
> >>>>>> + * hw init of individual IPs is performed here. This is different=
 from the
> >>>>>> + * 'common block' which initializes a set of IPs.
> >>>>>> + */
> >>>>>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
> >>>>>> +{
> >>>>>> +       /* Remap HDP registers to a hole in mmio space, for the pu=
rpose
> >>>>>> +        * of exposing those registers to process space. This need=
s to be
> >>>>>> +        * done before hw init of ip blocks to take care of HDP fl=
ush
> >>>>>> +        * operations through registers during hw_init.
> >>>>>> +        */
> >>>>>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_regist=
ers &&
> >>>>>> +           !amdgpu_sriov_vf(adev))
> >>>>>> +               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>>>> +}
> >>>>>>
> >>>>>>     /**
> >>>>>>      * amdgpu_device_ip_init - run init for hardware IPs
> >>>>>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdg=
pu_device *adev)
> >>>>>>                                    DRM_ERROR("amdgpu_vram_scratch_=
init failed %d\n", r);
> >>>>>>                                    goto init_failed;
> >>>>>>                            }
> >>>>>> +
> >>>>>> +                       amdgpu_device_prepare_ip(adev);
> >>>>>>                            r =3D adev->ip_blocks[i].version->funcs=
->hw_init((void *)adev);
> >>>>>>                            if (r) {
> >>>>>>                                    DRM_ERROR("hw_init %d failed %d=
\n", i, r);
> >>>>>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sri=
ov(struct amdgpu_device *adev)
> >>>>>>                    AMD_IP_BLOCK_TYPE_IH,
> >>>>>>            };
> >>>>>>
> >>>>>> +       amdgpu_device_prepare_ip(adev);
> >>>>>>            for (i =3D 0; i < adev->num_ip_blocks; i++) {
> >>>>>>                    int j;
> >>>>>>                    struct amdgpu_ip_block *block;
> >>>>>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(st=
ruct amdgpu_device *adev)
> >>>>>>     {
> >>>>>>            int i, r;
> >>>>>>
> >>>>>> +       amdgpu_device_prepare_ip(adev);
> >>>>>>            for (i =3D 0; i < adev->num_ip_blocks; i++) {
> >>>>>>                    if (!adev->ip_blocks[i].status.valid || adev->i=
p_blocks[i].status.hw)
> >>>>>>                            continue;
> >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd=
/amdgpu/nv.c
> >>>>>> index b3fba8dea63c..3ac7fef74277 100644
> >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
> >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
> >>>>>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
> >>>>>>            nv_program_aspm(adev);
> >>>>>>            /* setup nbio registers */
> >>>>>>            adev->nbio.funcs->init_registers(adev);
> >>>>>> -       /* remap HDP registers to a hole in mmio space,
> >>>>>> -        * for the purpose of expose those registers
> >>>>>> -        * to process space
> >>>>>> -        */
> >>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov=
_vf(adev))
> >>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>>>>            /* enable the doorbell aperture */
> >>>>>>            nv_enable_doorbell_aperture(adev, true);
> >>>>>>
> >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/=
amd/amdgpu/soc15.c
> >>>>>> index fde6154f2009..a0481e37d7cf 100644
> >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> >>>>>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handl=
e)
> >>>>>>            soc15_program_aspm(adev);
> >>>>>>            /* setup nbio registers */
> >>>>>>            adev->nbio.funcs->init_registers(adev);
> >>>>>> -       /* remap HDP registers to a hole in mmio space,
> >>>>>> -        * for the purpose of expose those registers
> >>>>>> -        * to process space
> >>>>>> -        */
> >>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov=
_vf(adev))
> >>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>>>>
> >>>>>>            /* enable the doorbell aperture */
> >>>>>>            soc15_enable_doorbell_aperture(adev, true);
> >>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/=
amd/amdgpu/soc21.c
> >>>>>> index 55284b24f113..16b447055102 100644
> >>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
> >>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
> >>>>>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
> >>>>>>            soc21_program_aspm(adev);
> >>>>>>            /* setup nbio registers */
> >>>>>>            adev->nbio.funcs->init_registers(adev);
> >>>>>> -       /* remap HDP registers to a hole in mmio space,
> >>>>>> -        * for the purpose of expose those registers
> >>>>>> -        * to process space
> >>>>>> -        */
> >>>>>> -       if (adev->nbio.funcs->remap_hdp_registers)
> >>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
> >>>>>>            /* enable the doorbell aperture */
> >>>>>>            soc21_enable_doorbell_aperture(adev, true);
> >>>>>>
> >>>>>> --
> >>>>>> 2.25.1
> >>>>>>
