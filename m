Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60D75653BD
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiGDLgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiGDLgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:36:10 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8F81144F;
        Mon,  4 Jul 2022 04:36:04 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lc3fD2WDCz4xZj;
        Mon,  4 Jul 2022 21:36:04 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <98a4c2603bf9e4b776e219f5b8541d23aa24e854.1654930308.git.christophe.leroy@csgroup.eu>
References: <98a4c2603bf9e4b776e219f5b8541d23aa24e854.1654930308.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc: Restore CONFIG_DEBUG_INFO in defconfigs
Message-Id: <165693440488.9954.15240124724285203311.b4-ty@ellerman.id.au>
Date:   Mon, 04 Jul 2022 21:33:24 +1000
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

On Sat, 11 Jun 2022 08:51:57 +0200, Christophe Leroy wrote:
> Commit f9b3cd245784 ("Kconfig.debug: make DEBUG_INFO selectable from a
> choice") broke the selection of CONFIG_DEBUG_INFO by powerpc defconfigs.
> 
> It is now necessary to select one of the three DEBUG_INFO_DWARF*
> options to get DEBUG_INFO enabled.
> 
> Replace DEBUG_INFO=y by DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y in all
> defconfigs using the following command:
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc: Restore CONFIG_DEBUG_INFO in defconfigs
      https://git.kernel.org/powerpc/c/92f89ec1b534b6eca2b81bae97d30a786932f51a

cheers
