Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA896CC887
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 18:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjC1QwD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 28 Mar 2023 12:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC1QwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 12:52:01 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7763F61B5;
        Tue, 28 Mar 2023 09:51:59 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 64FC161989E6;
        Tue, 28 Mar 2023 18:51:57 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id rSqEHlFbiw2K; Tue, 28 Mar 2023 18:51:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id A0DF061989F6;
        Tue, 28 Mar 2023 18:51:56 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id G1mmPBPF4NNz; Tue, 28 Mar 2023 18:51:56 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 75C9361989E6;
        Tue, 28 Mar 2023 18:51:56 +0200 (CEST)
Date:   Tue, 28 Mar 2023 18:51:56 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Bang Li <libang.linuxer@gmail.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1646372169.361736.1680022316353.JavaMail.zimbra@nod.at>
In-Reply-To: <20230328163012.4264-1-libang.linuxer@gmail.com>
References: <20230328163012.4264-1-libang.linuxer@gmail.com>
Subject: Re: [PATCH v2] mtdblock: tolerate corrected bit-flips
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: mtdblock: tolerate corrected bit-flips
Thread-Index: ouKfcIuIMflG9wXsCuCDxoFYiHDGng==
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Bang Li" <libang.linuxer@gmail.com>
> An: "Miquel Raynal" <miquel.raynal@bootlin.com>, "richard" <richard@nod.at>, "Vignesh Raghavendra" <vigneshr@ti.com>
> CC: "linux-mtd" <linux-mtd@lists.infradead.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "Bang Li"
> <libang.linuxer@gmail.com>, "stable" <stable@vger.kernel.org>
> Gesendet: Dienstag, 28. März 2023 18:30:12
> Betreff: [PATCH v2] mtdblock: tolerate corrected bit-flips

> mtd_read() may return -EUCLEAN in case of corrected bit-flips.This
> particular condition should not be treated like an error.
> 
> Signed-off-by: Bang Li <libang.linuxer@gmail.com>
> Fixes: e47f68587b82 ("mtd: check for max_bitflips in mtd_read_oob()")
> Cc: <stable@vger.kernel.org> # v3.7
> ---

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
