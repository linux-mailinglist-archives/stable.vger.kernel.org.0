Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE8A6A545D
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 09:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjB1I26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 03:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjB1I25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 03:28:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13D126D7
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 00:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5541E60FB6
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 08:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617C4C433EF;
        Tue, 28 Feb 2023 08:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677572926;
        bh=kKR2VXV5T7q7vyn3FE2qodUASqy7x3m1sm3A5wpu7zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jxDYNaWlH5B6CqDuz01DyfgUH2B+8Htm9Olu3aGt/zKyq1CTFvvtA6GDgq4sjy7ts
         WixYZF6bMWE5331kIouN0dWJMfh5yb+iATBTaK7c0Sb7szETF73ytq7XMKTOAgy8gx
         JYDYyYrOuoX7XBjZN/DWcQzO3y95BpdD3oYd0LUM=
Date:   Tue, 28 Feb 2023 09:28:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?546L5piK54S2?= <msl0000023508@gmail.com>
Cc:     stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Kevin Hao <haokexin@gmail.com>
Subject: Re: Symbol cpu_feature_keys should be exported to all modules on
 powerpc
Message-ID: <Y/27PBzfeRNEhWnA@kroah.com>
References: <CAPge7ycxEpms_wQoDoCncz743N2BfzVCZPLmbHCVTs6ZKSp=nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPge7ycxEpms_wQoDoCncz743N2BfzVCZPLmbHCVTs6ZKSp=nA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 04:18:12PM +0800, 王昊然 wrote:
> Just like symbol 'mmu_feature_keys'[1], 'cpu_feature_keys' was referenced
> indirectly by many inline functions; any GPL-incompatible modules using such
> a function will be potentially broken due to 'cpu_feature_keys' being
> exported as GPL-only.
> 
> For example it still breaks ZFS, see
> https://github.com/openzfs/zfs/issues/14545
> 
> [1]: https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220329085709.4132729-1-haokexin@gmail.com/

External modules are always on their own, sorry.  Especially ones that
are not released under the GPL.

good luck!

greg k-h
