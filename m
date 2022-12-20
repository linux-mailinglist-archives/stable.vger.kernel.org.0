Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D24A6525D2
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 18:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiLTRyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 12:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiLTRyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 12:54:11 -0500
Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACF7DFDD;
        Tue, 20 Dec 2022 09:54:09 -0800 (PST)
Date:   Tue, 20 Dec 2022 17:54:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fanf.eu;
        s=protonmail; t=1671558847; x=1671818047;
        bh=YjIrzqQGcrOiPUWhgGtB+g/tDdsalo99mkx+OIkMm1c=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=YqSnxXgtCs4jDQzc2UB5o2+ZP49gzOBeVGTyd3DlWOMVQFj5QBIMT2eeAOvL69K2n
         dxDJ2dMYH/+wfEY7aRCaTj08TgY5a67HPx3lUhNEkB+DOo0az5NesPDsbU5eMWXjMW
         0aA5HM/YKhNlKgb3xGE03I9921fSYVPRO856Ti0o=
To:     mario.limonciello@amd.com
From:   "francois@fanf.eu" <francois@fanf.eu>
Cc:     Shyam-sundar.S-k@amd.com, anson.tsao@amd.com, ben@bcheng.me,
        bilkow@tutanota.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@zogpog.com,
        philipp.zabel@gmail.com, rafael.j.wysocki@intel.com,
        rafael@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+
Message-ID: <fb729a11-46e4-4aab-bfa5-42afca476785@fanf.eu>
Feedback-ID: 8996646:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Thu, Dec 15, 2022 at 01:16:16PM -0600 schrieb Mario Limonciello:
> After we introduced a module parameter and quirk infrastructure for  > pi=
cking the Microsoft GUID over the SOC vendor GUID we discovered >
that lots and lots of systems are getting this wrong. > > The table
continues to grow, and is becoming unwieldy. > > We don't really have
any benefit to forcing vendors to populate the > AMD GUID. This is just
extra work, and more and more vendors seem > to mess it up. As the
Microsoft GUID is used by Windows as well, > it's very likely that it
won't be messed up like this. > > So drop all the quirks forcing it and
the Rembrandt behavior. This > means that Cezanne or later effectively
only run the Microsoft GUID > codepath with the exception of HP
Elitebook 8*5 G9. > > Fixes: fd894f05cf30 ("ACPI: x86: s2idle: If a new
AMD _HID is missing assume Rembrandt") > Cc: stable@vger.kernel.org #
6.1 > Reported-by: Benjamin Cheng <ben@bcheng.me> > Reported-by:
bilkow@tutanota.com > Reported-by: Paul <paul@zogpog.com> > Link:
https://gitlab.freedesktop.org/drm/amd/-/issues/2292 > Link:
https://bugzilla.kernel.org/show_bug.cgi?id=3D216768 > Signed-off-by:
Mario Limonciello <mario.limonciello@amd.com> Tested-by: Fran=C3=A7ois ARMA=
ND <francois@fanf.eu>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2307

Regards - and thanks for the help Mario!
Fran=C3=A7ois



