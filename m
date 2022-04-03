Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF794F08B9
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 12:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349380AbiDCK1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 06:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiDCK1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 06:27:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6276B3703B;
        Sun,  3 Apr 2022 03:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01BE360FF5;
        Sun,  3 Apr 2022 10:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105FAC340ED;
        Sun,  3 Apr 2022 10:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648981518;
        bh=5Rk4qBo8KXJ4pr3Qpiy8Eu9Kz/J1L0747NXzlOSzJi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SoKcXSKYMDvsbzLtCxrrCDqphCXUJbQxEoSBtuD4VXHCAvGM5kr7r4Uz82qxAJSra
         zNx2Rm0t//TUih4NHD0qsDbZv/fSNOybngmlTuHAJVHyBvJsXuI4re5cX//dVM6Jk4
         Eo9eimXz2ZIuikECXq24VTMI7oXtF8bAh/0rGWZw=
Date:   Sun, 3 Apr 2022 12:25:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Chen Jingwen <chenjingwen6@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] [Rebased for 5.4] powerpc/kasan: Fix early region not
 updated correctly
Message-ID: <Ykl2C6DmSKWxlOWE@kroah.com>
References: <fc39c36ea92e03ed5eb218ddbe83b34361034d9d.1648915982.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc39c36ea92e03ed5eb218ddbe83b34361034d9d.1648915982.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 06:13:31PM +0200, Christophe Leroy wrote:
> From: Chen Jingwen <chenjingwen6@huawei.com>
> 
> This is backport for 5.4
> 
> Upstream commit 5647a94a26e352beed61788b46e035d9d12664cd

This is not a commit in Linus's tree :(

