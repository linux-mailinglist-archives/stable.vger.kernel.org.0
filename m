Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF134B4D79
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349401AbiBNKwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:52:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350378AbiBNKvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:51:16 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CED77A8A;
        Mon, 14 Feb 2022 02:15:47 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4Jy0V924ftz1r86y;
        Mon, 14 Feb 2022 11:15:45 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4Jy0V90YlFz1qqkG;
        Mon, 14 Feb 2022 11:15:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ciTL-mIIXXIv; Mon, 14 Feb 2022 11:15:44 +0100 (CET)
X-Auth-Info: k0w8anaaY5GOMTg9kubk4prPg/gPXdju+Qta5i8aIzT4i0LbN2ihZ0bcWJdLYcD/
Received: from igel.home (ppp-46-244-178-131.dynamic.mnet-online.de [46.244.178.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 14 Feb 2022 11:15:44 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id BF2382C394F; Mon, 14 Feb 2022 11:15:43 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>, stable@vger.kernel.org,
        Sunil V L <sunilvl@ventanamicro.com>
Subject: Re: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return
 value
References: <20220128045004.4843-1-sunilvl@ventanamicro.com>
        <877d9xx14f.fsf@igel.home>
        <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de>
X-Yow:  The LOGARITHM of an ISOSCELES TRIANGLE is TUESDAY WELD!!
Date:   Mon, 14 Feb 2022 11:15:43 +0100
In-Reply-To: <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de> (Heinrich
        Schuchardt's message of "Mon, 14 Feb 2022 10:24:22 +0100")
Message-ID: <87tud1vjn4.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Feb 14 2022, Heinrich Schuchardt wrote:

> set_boot_hartid() implies that the caller can change the boot hart ID.
> As this is not a case this name obviously would be a misnomer.

initialize_boot_hartid would fit better.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
