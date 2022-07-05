Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A67567682
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 20:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiGESbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 14:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiGESbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 14:31:24 -0400
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291DB1CFEF;
        Tue,  5 Jul 2022 11:31:23 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-31caffa4a45so46145967b3.3;
        Tue, 05 Jul 2022 11:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6hukL7B2L1BwxNslotJavxUddmkxk+OohGZWY84yU8=;
        b=hswwj192jo5nRVAOQ79R9glcovakp/ip/fdunL89uyVkFp5JteXkRbLyaFJDaVIpc3
         meb8jki8s3IxOwfTh8msqlWZTE3vA0prB4iyTQ6YjmaAf3hmVDTxJSZuODI0Vu72RFEv
         23eWGOcXxW9+KR1cAsfQ/9jNBMuUEHdLrMe9XyTIOgfzDWGKx1c9ulQXxBR44g2jHrkn
         FOl4IC1GuIN5uwJciA7OCZer/G0wSTLKRNhtl7pwkt4yrQ984c0ztrznEtsIY5H3lAvG
         vo6Cg0qCMnIaRhxCaWjTKXfdQ1V9O74NZTxJuhFWQE/RXcxw8wpLpCAx1NnrHJG8tPPt
         g85w==
X-Gm-Message-State: AJIora8/vq7BglIq1PQ6deMjAYzEnTB7+sA+OwReeuGNYDFXA6Q2dT8C
        lt7jLiuBHB1C76Pyninp718Ov4DLVh+t592uAhM=
X-Google-Smtp-Source: AGRyM1t/fXIbLK4LOjtkjSo0hXN2bOO29vTGdHLhb5iwUnkhafwJp4vskczPEW9bcv0AiYfyJb2Gny9Oy4j8M5y0lDI=
X-Received: by 2002:a0d:c486:0:b0:31c:3b63:91fe with SMTP id
 g128-20020a0dc486000000b0031c3b6391femr36249582ywd.7.1657045882313; Tue, 05
 Jul 2022 11:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220630022317.15734-1-gch981213@gmail.com> <b84edc24-0a3a-a4d2-6481-fb3d4cee6dda@amd.com>
 <CAJsYDVL=fgExYdw3JB-59rCwOqTbSt2N0Xw2WCmoTSzOQEMRRg@mail.gmail.com>
 <CAJZ5v0g7JOcYTwwLxPws38abn_EVGjG0+QY9E+qpM=guhF11tA@mail.gmail.com> <MN0PR12MB61010151CDD4D74F75619684E2819@MN0PR12MB6101.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB61010151CDD4D74F75619684E2819@MN0PR12MB6101.namprd12.prod.outlook.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 5 Jul 2022 20:31:11 +0200
Message-ID: <CAJZ5v0h8_AEH2XgB_Zk2NKH01wBo9+YaB=V557m9H_1PBy_wQw@mail.gmail.com>
Subject: Re: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        Kent Hou Man <knthmn0@gmail.com>,
        Len Brown <lenb@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 5, 2022 at 8:27 PM Limonciello, Mario
<Mario.Limonciello@amd.com> wrote:
>
> [Public]
>
> > -----Original Message-----
> > From: Rafael J. Wysocki <rafael@kernel.org>
> > Sent: Tuesday, July 5, 2022 13:24
> > To: Chuanhong Guo <gch981213@gmail.com>
> > Cc: Rafael J. Wysocki <rafael@kernel.org>; Limonciello, Mario
> > <Mario.Limonciello@amd.com>; ACPI Devel Maling List <linux-
> > acpi@vger.kernel.org>; Stable <stable@vger.kernel.org>; Tighe Donnelly
> > <tighe.donnelly@protonmail.com>; Kent Hou Man <knthmn0@gmail.com>;
> > Len Brown <lenb@kernel.org>; open list <linux-kernel@vger.kernel.org>
> > Subject: Re: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
> >
> > On Fri, Jul 1, 2022 at 2:45 PM Chuanhong Guo <gch981213@gmail.com>
> > wrote:
> > >
> > > On Fri, Jul 1, 2022 at 4:12 AM Limonciello, Mario
> > > <mario.limonciello@amd.com> wrote:
> > > > However I do want to point out that Windows doesn't care about legacy
> > > > format or not.  This bug where keyboard doesn't work only popped up on
> > > > Linux.
> > > >
> > > > Given the number of systems with the bug is appearing to grow I wonder
> > > > if the right answer is actually a new heuristic that doesn't apply the
> > > > kernel override for polarity inversion anymore.  Maybe if the system is
> > > > 2022 or newer?  Or on the ACPI version?
> > >
> > > The previous attempt to limit the scope of IRQ override ends up
> > > breaking some other buggy devices:
> > >
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatc
> > hwork.kernel.org%2Fproject%2Flinux-
> > acpi%2Fpatch%2F20210728151958.15205-1-
> > hui.wang%40canonical.com%2F&amp;data=05%7C01%7Cmario.limonciello%4
> > 0amd.com%7C106955e4611344d3bc3808da5eb3971d%7C3dd8961fe4884e608
> > e11a82d994e183d%7C0%7C0%7C637926422673112765%7CUnknown%7CTWF
> > pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXV
> > CI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=xOaRbkCv9EMhpLO%2BGAP
> > mDjEhQ78xjYFBvehLZdg1k1I%3D&amp;reserved=0
> > >
> > > It's unfortunate that the original author of this IRQ override doesn't
> > > limit the scope to their exact devices.
> > >
> > > Hi, Rafael! What do you think? should we skip this IRQ override
> > > one-by-one or add a different matching logic to check the bios date
> > > instead?
> >
> > It would be better to find something precise enough to identify the
> > machines in question without pulling in the others and use that for
> > skipping the override instead of listing them all one by one in the
> > blocklist.
>
> How about using the CPU family/model in this case?

That would work for me.  The code in question is all quirks anyway.
