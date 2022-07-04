Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27495653B8
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiGDLgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiGDLgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:36:07 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FD010FC9;
        Mon,  4 Jul 2022 04:36:02 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lc3f90WZ5z4xYY;
        Mon,  4 Jul 2022 21:36:00 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <0c33b96317811edf691e81698aaee8fa45ec3449.1656427391.git.christophe.leroy@csgroup.eu>
References: <0c33b96317811edf691e81698aaee8fa45ec3449.1656427391.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
Message-Id: <165693441432.9954.15776721624339561101.b4-ty@ellerman.id.au>
Date:   Mon, 04 Jul 2022 21:33:34 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Jun 2022 16:43:35 +0200, Christophe Leroy wrote:
> On FSL_BOOK3E, _PAGE_RW is defined with two bits, one for user and one
> for supervisor. As soon as one of the two bits is set, the page has
> to be display as RW. But the way it is implemented today requires both
> bits to be set in order to display it as RW.
> 
> Instead of display RW when _PAGE_RW bits are set and R otherwise,
> reverse the logic and display R when _PAGE_RW bits are all 0 and
> RW otherwise.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
      https://git.kernel.org/powerpc/c/dd8de84b57b02ba9c1fe530a6d916c0853f136bd

cheers
