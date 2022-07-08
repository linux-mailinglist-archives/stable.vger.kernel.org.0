Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDBC56B575
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 11:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiGHJWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 05:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbiGHJWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 05:22:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B282FFCA
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 02:22:49 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cp18-20020a17090afb9200b001ef79e8484aso1087992pjb.1
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 02:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fortu-net.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0gFTgEw8o/sZzcpqT/zqeJVyFwXwGnVGICet2zwIx0=;
        b=sBE6RD34qzqgs778DVxBQqGSxgy5SBH9j19gPIGTpGn01WSwkFlOGZ+0RiCGEdX9mW
         BCWm4cukAIrNz3heoRcLqTnzf6Fb79D91vPm7Lul7XyT1jL0ol+sPsszXJGakic9tb/8
         gfR1UWNSuMBmeFIxDl4gwFfphGhhWoH3sPlGZpW4bMJlQCmRA5UcpHxESPODbmJXEAr4
         kdFbbvX83cDRmE7PQ+GWVqwtNaCR1AulbaGNQ/KsDJNhiwS4zGei/rWMUrMhN939PioD
         uBXBidrjE5H0VGsKmPBH6sczfM+gMgRxw7aC42HHLotuLdaGJ16/YLJvLW1aDXSceD/L
         GKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0gFTgEw8o/sZzcpqT/zqeJVyFwXwGnVGICet2zwIx0=;
        b=fgSN6dEjAZqwQbourtALuFyY2zp/kT7cYD5Pn4DCGQCCW7D+DL2Klr57VnCFCPScgC
         9o9ShT7Yc/FOJ717wnUA18pYRgLh+8FtRUAJR+XFaPHXRJvlH6Uqoh3PZ/jQeildFnt6
         rtYTj34xduLNRN36kBNL5ALcdf0pGQhgAtMRleMoWsi1hAinBaPahXSjNsVds8tq/2hN
         F419iTYrBWZ6ZAbDYVhS/KAZYvz7W1yBf6tVBNFYmkFVRbA4+pYNE9MZfv/yRJ0VzOw7
         mPDmNNv4h3DtHNx66T+Dpf5PyEtdf6Q9guICpJkOQY/IYNAMWQ6x3vAs/7vwIDOUstW7
         aW/g==
X-Gm-Message-State: AJIora/dOJozXyVk2nj1MdUF7V+oQ95LxMyniqGpoKbWhA4N88FgYT2o
        rCfu1xpOjPIlh8IahedorKAL5LjGab/+TQSPXBj5Q1J1jsNpcYYF8nJY
X-Google-Smtp-Source: AGRyM1uSZoyIcGr4GVhCV/Gjjw1nutNmCi1SbSgTEu383XlWcc1SQglU0jXyjf7VafdFTCkZc0/UUxzUY0BmyFrRH8k=
X-Received: by 2002:a17:90b:1b07:b0:1ec:c617:a314 with SMTP id
 nu7-20020a17090b1b0700b001ecc617a314mr2890719pjb.214.1657272169161; Fri, 08
 Jul 2022 02:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220328111828.1554086-1-sashal@kernel.org> <20220328111828.1554086-42-sashal@kernel.org>
 <872f2a21-7bf7-0cc3-298f-f817429f6997@fortu.net> <MN0PR12MB6101729CF68952653E8F55EFE2839@MN0PR12MB6101.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB6101729CF68952653E8F55EFE2839@MN0PR12MB6101.namprd12.prod.outlook.com>
From:   Tom Crossland <tomc@fortu.net>
Date:   Fri, 8 Jul 2022 11:22:38 +0200
Message-ID: <CACdrSeLjKDDpBG3=FZowro_vPGNmwbwvF6iVKw7QkVhgU6LgxQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 42/43] Revert "ACPI: Pass the same
 capabilities to the _OSC regardless of the query flag"
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Huang, Ray" <Ray.Huang@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I can confirm that the ACPI BIOS Errors no longer appear in the kernel
log using mainline 5.19.0-rc5 with the patch applied.

Many thanks

On Thu, Jul 7, 2022 at 11:36 PM Limonciello, Mario
<Mario.Limonciello@amd.com> wrote:
>
> [Public]
>
>
>
> > -----Original Message-----
> > From: Tom Crossland <tomc@fortu.net>
> > Sent: Thursday, July 7, 2022 16:31
> > To: Sasha Levin <sashal@kernel.org>; linux-kernel@vger.kernel.org;
> > stable@vger.kernel.org
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>; Limonciello, Mario
> > <Mario.Limonciello@amd.com>; Huang, Ray <Ray.Huang@amd.com>; Mika
> > Westerberg <mika.westerberg@linux.intel.com>; rafael@kernel.org; linux-
> > acpi@vger.kernel.org
> > Subject: Re: [PATCH AUTOSEL 5.17 42/43] Revert "ACPI: Pass the same
> > capabilities to the _OSC regardless of the query flag"
> >
> > Hi, I'm observing the issue described here which I think is due to a
> > recent regression:
> >
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.c
> > om%2Fintel%2Flinux-intel-
> > lts%2Fissues%2F22&amp;data=05%7C01%7CMario.Limonciello%40amd.com%7
> > C77419b612f9540e333ff08da606002ee%7C3dd8961fe4884e608e11a82d994e18
> > 3d%7C0%7C0%7C637928263354159054%7CUnknown%7CTWFpbGZsb3d8eyJWI
> > joiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300
> > 0%7C%7C%7C&amp;sdata=X%2FEAU9GbRD%2FfYxCMUmnWI1cJ8dk8sICk0iYu
> > %2BKGqtl4%3D&amp;reserved=0
> >
> > sudo dmesg -t -l err
> >
> > ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC],
> > AE_NOT_FOUND (20211217/psargs-330)
> > ACPI Error: Aborting method \_PR.PR01._CPC due to previous error
> > (AE_NOT_FOUND) (20211217/psparse-529)
> > ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC],
> > AE_NOT_FOUND (20211217/psargs-330)
> > ACPI Error: Aborting method \_PR.PR02._CPC due to previous error
> > (AE_NOT_FOUND) (20211217/psparse-529)
> > ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC],
> > AE_NOT_FOUND (20211217/psargs-330)
> > ACPI Error: Aborting method \_PR.PR03._CPC due to previous error
> > (AE_NOT_FOUND) (20211217/psparse-529)
> >
> > System:
> >    Kernel: 5.18.9-arch1-1 arch: x86_64 bits: 64 compiler: gcc v: 12.1.0
> >      parameters: initrd=\intel-ucode.img initrd=\initramfs-linux.img
> >      root=xxx intel_iommu=on iommu=pt
> >   Machine:
> >    Type: Desktop Mobo: Intel model: NUC7i5BNB v: J31144-304 serial: <filter>
> >      UEFI: Intel v: BNKBL357.86A.0088.2022.0125.1102 date: 01/25/2022
> >
> > I hope this is the correct forum to report the issue. Apologies if not.
> >
>
> This is the fix for it:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&id=7feec7430edddb87c24b0a86b08a03d0b496a755
>
>
> > On 28/03/2022 13.18, Sasha Levin wrote:
> > > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> > >
> > > [ Upstream commit 2ca8e6285250c07a2e5a22ecbfd59b5a4ef73484 ]
> > >
> > > Revert commit 159d8c274fd9 ("ACPI: Pass the same capabilities to the
> > > _OSC regardless of the query flag") which caused legitimate usage
> > > scenarios (when the platform firmware does not want the OS to control
> > > certain platform features controlled by the system bus scope _OSC) to
> > > break and was misguided by some misleading language in the _OSC
> > > definition in the ACPI specification (in particular, Section 6.2.11.1.3
> > > "Sequence of _OSC Calls" that contradicts other perts of the _OSC
> > > definition).
> > >
> > > Link:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.ker
> > nel.org%2Flinux-
> > acpi%2FCAJZ5v0iStA0JmO0H3z%2BVgQsVuQONVjKPpw0F5HKfiq%3DGb6B5yw%
> > 40mail.gmail.com&amp;data=05%7C01%7CMario.Limonciello%40amd.com%7C
> > 77419b612f9540e333ff08da606002ee%7C3dd8961fe4884e608e11a82d994e183
> > d%7C0%7C0%7C637928263354159054%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> > oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300
> > 0%7C%7C%7C&amp;sdata=Te3BK%2B0q2QmrqqoG5mbV%2FNguoMgiwzILNHl
> > %2BhUMLFlY%3D&amp;reserved=0
> > > Reported-by: Mario Limonciello <Mario.Limonciello@amd.com>
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Tested-by: Mario Limonciello <mario.limonciello@amd.com>
> > > Acked-by: Huang Rui <ray.huang@amd.com>
> > > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >   drivers/acpi/bus.c | 27 +++++++++++++++++++--------
> > >   1 file changed, 19 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > > index 07f604832fd6..079b952ab59f 100644
> > > --- a/drivers/acpi/bus.c
> > > +++ b/drivers/acpi/bus.c
> > > @@ -332,21 +332,32 @@ static void
> > acpi_bus_osc_negotiate_platform_control(void)
> > >     if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
> > >             return;
> > >
> > > -   kfree(context.ret.pointer);
> > > +   capbuf_ret = context.ret.pointer;
> > > +   if (context.ret.length <= OSC_SUPPORT_DWORD) {
> > > +           kfree(context.ret.pointer);
> > > +           return;
> > > +   }
> > >
> > > -   /* Now run _OSC again with query flag clear */
> > > +   /*
> > > +    * Now run _OSC again with query flag clear and with the caps
> > > +    * supported by both the OS and the platform.
> > > +    */
> > >     capbuf[OSC_QUERY_DWORD] = 0;
> > > +   capbuf[OSC_SUPPORT_DWORD] =
> > capbuf_ret[OSC_SUPPORT_DWORD];
> > > +   kfree(context.ret.pointer);
> > >
> > >     if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
> > >             return;
> > >
> > >     capbuf_ret = context.ret.pointer;
> > > -   osc_sb_apei_support_acked =
> > > -           capbuf_ret[OSC_SUPPORT_DWORD] &
> > OSC_SB_APEI_SUPPORT;
> > > -   osc_pc_lpi_support_confirmed =
> > > -           capbuf_ret[OSC_SUPPORT_DWORD] &
> > OSC_SB_PCLPI_SUPPORT;
> > > -   osc_sb_native_usb4_support_confirmed =
> > > -           capbuf_ret[OSC_SUPPORT_DWORD] &
> > OSC_SB_NATIVE_USB4_SUPPORT;
> > > +   if (context.ret.length > OSC_SUPPORT_DWORD) {
> > > +           osc_sb_apei_support_acked =
> > > +                   capbuf_ret[OSC_SUPPORT_DWORD] &
> > OSC_SB_APEI_SUPPORT;
> > > +           osc_pc_lpi_support_confirmed =
> > > +                   capbuf_ret[OSC_SUPPORT_DWORD] &
> > OSC_SB_PCLPI_SUPPORT;
> > > +           osc_sb_native_usb4_support_confirmed =
> > > +                   capbuf_ret[OSC_SUPPORT_DWORD] &
> > OSC_SB_NATIVE_USB4_SUPPORT;
> > > +   }
> > >
> > >     kfree(context.ret.pointer);
> > >   }
