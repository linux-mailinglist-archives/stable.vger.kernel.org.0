Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F70465A942
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 09:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjAAIOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 03:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAAIOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 03:14:31 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D2D60CE
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 00:14:27 -0800 (PST)
Date:   Sun, 01 Jan 2023 08:14:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.kalamlacki.eu;
        s=protonmail2; t=1672560865; x=1672820065;
        bh=fk7nfaW8ayclcL3dWOnZXqB20Y99+DA35+qa83+3yso=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=h56Iahr6uKURb1h4QKs71gUC0sXQK3nUY7WfJ9cwI1WhtkXqKds0/8lWKEu0uocHQ
         zL4rxbX9xjzEt0AmRncL38KwDXQC+P4rTeq03C5RFStSLxeNGIOGQpbAWCD9MHuApN
         12Nn0GyBgUJ/I8JUeQ7izyZuIEv9YJ2a+2ud+vF0C6Rq2RFk8trTyNc7RRZxtm2Haw
         1lCMUYP7cWY83TtdcAzn492tNjl0E8CCT0icxcxjVpSL6Wt9ov4rSNKlx+3wfnEoxp
         fM+mMOKbESLpRrM288j4kF1vntEnZSa+9c7X4AaMoRWDDgYlmo7iIcPAy6f7JxYpnh
         dmCymzEZ64loA==
To:     Willy Tarreau <w@1wt.eu>
From:   =?utf-8?Q?=C5=81ukasz_Kalam=C5=82acki?= <lukasz@pm.kalamlacki.eu>
Cc:     stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu>
In-Reply-To: <20230101065337.GA20539@1wt.eu>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu> <20230101065337.GA20539@1wt.eu>
Feedback-ID: 42407704:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1.01.2023 07:53, Willy Tarreau wrote:
> On Sat, Dec 31, 2022 at 04:58:51PM +0000, Lukasz Kalamlacki wrote:
>> Hey,
>>
>>
>> Do you have an issue compiling 6.1.2 linux kernel?
>>
>> I cannot compile it.
> For me it compiles and boots. You'll need to share your config and error
> report if you want to get some help.
>
> Willy

I was trying to compile on Debian Bullseye where default gcc is version
10, when I upgraded gcc to version 12 from sid repo i Was able to
compile too. On stable Debian without addition during compile
"segmentation fault" occurs at the compilation of cx8-i2c.c file. You
can try on kvm or virtualbox this compilation.


Best,

=C5=81ukasz


