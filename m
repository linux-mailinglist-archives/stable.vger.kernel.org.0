Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C4966656E
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbjAKVRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 16:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjAKVRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 16:17:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445593F461;
        Wed, 11 Jan 2023 13:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95BE61E74;
        Wed, 11 Jan 2023 21:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6C7C433EF;
        Wed, 11 Jan 2023 21:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673471828;
        bh=QdcJvdniwrZcZmbcSbOer2XLC8w4zwY1Sh2DDpeRZBE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Zg+MIILrTXGW8KxXp2z2qWP5oE2R0DpAQ3jqnA28F/gResrypj/V9XhV0VR9u/b3O
         Af1MinfQ3x/0cEb549086NlK578BWsjX6RsNqBn6xjopdvLsyYNB+sSPxCmPdkEljT
         LLj8JHWoYQ0Un2875tkjtOPiwSPwWV2gn+1EJwLEomTCRTSjNTEWhAqJbnON4xjrzw
         NhdMmO6TJqlAYYngD0bVAMt3mVb5ybVbDT1jAoQba+Lt7uRLDQs9AzHOAv2KqARvtl
         LIIG/kuN6tQ7kLJ7i67nqstwETWbiUU5cfLpTWUL1vlIdHKls4dMRdbZR5df0dRcjr
         OPFj0rjs/99Sg==
Received: by mail-lf1-f50.google.com with SMTP id d30so20576497lfv.8;
        Wed, 11 Jan 2023 13:17:08 -0800 (PST)
X-Gm-Message-State: AFqh2koals5/JoF0nM9UJXFhYPW+Pi1gViLwfe5GGMBH1lFlhHbsGIq5
        z3X6XDgFLGDGIbOUi8xTcJvF3YZhNYi4meZ1aVU=
X-Google-Smtp-Source: AMrXdXuBBSwcAiqP8KFCO40rWyFMOcfLVKYmvyMB5eDhDtB3rGI2GHTWeHyQTyXlKOPv/utmYODtcMD51fJraDPBYvw=
X-Received: by 2002:a05:6512:3d93:b0:4b8:9001:a694 with SMTP id
 k19-20020a0565123d9300b004b89001a694mr3571126lfv.426.1673471826196; Wed, 11
 Jan 2023 13:17:06 -0800 (PST)
MIME-Version: 1.0
References: <20230111132734.1571990-1-ardb@kernel.org> <CAJZ5v0hZMGMBnYog1CwUfGe8WU9GHmNgdn3gJdwdpiz-V2J-Ow@mail.gmail.com>
In-Reply-To: <CAJZ5v0hZMGMBnYog1CwUfGe8WU9GHmNgdn3gJdwdpiz-V2J-Ow@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 11 Jan 2023 22:16:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFyba7e3mVeV2F+g85+1coYJotK=PFpvia6gAD8j1=tog@mail.gmail.com>
Message-ID: <CAMj1kXFyba7e3mVeV2F+g85+1coYJotK=PFpvia6gAD8j1=tog@mail.gmail.com>
Subject: Re: [PATCH] ACPI: PRM: Check whether EFI runtime is available
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     linux-efi@vger.kernel.org, stable@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 11 Jan 2023 at 21:23, Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Jan 11, 2023 at 2:27 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > The ACPI PRM address space handler calls efi_call_virt_pointer() to
> > execute PRM firmware code, but doing so is only permitted when the EFI
> > runtime environment is available. Otherwise, such calls are guaranteed
> > to result in a crash, and must therefore be avoided.
> >
> > Cc: <stable@vger.kernel.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: linux-acpi@vger.kernel.org
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  drivers/acpi/prmt.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
> > index 998101cf16e47145..74f924077866ae69 100644
> > --- a/drivers/acpi/prmt.c
> > +++ b/drivers/acpi/prmt.c
> > @@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
> >         efi_status_t status;
> >         struct prm_context_buffer context;
> >
> > +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> > +               pr_err("PRM: EFI runtime services unavailable\n");
> > +               return AE_NOT_IMPLEMENTED;
> > +       }
> > +
>
> Does the check need to be made in the address space handler and if so, then why?
>

Yes. efi_enabled(EFI_RUNTIME_SERVICES) will transition from true to
false if an exception occurs while executing the firmware code.

Unlike the EFI variable runtime services, which are quite uniform,
this PRM code will be vendor specific, and so the likelihood that it
is buggy and only tested with Windows is much higher, and so I would
like us to be more cautious here.

> It looks like it would be better to prevent it from being installed if
> EFI runtime services are not enabled in the first place, in
> init_prmt().
>

We could add another check there as well, yes. And perhaps the one in
the handler should we pr_warn_once() to prevent it from firing
repeatedly.

> >         /*
> >          * The returned acpi_status will always be AE_OK. Error values will be
> >          * saved in the first byte of the PRM message buffer to be used by ASL.
> > --
