Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3776576371
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiGOOM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiGOOM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:12:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607846871A
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF8F8616EE
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 14:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB3EC34115;
        Fri, 15 Jul 2022 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657894374;
        bh=nZIHNSt68lLLcBz71QyJc0yhBVi7N38rUYlNX/xF0vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSHemPttlUz3su60SJvzO9uRaWbpm2hTYUI2KM/RhX0a013R6n1VWijyZKW+TdriD
         ahz4e5DSdT+w+J/a/GsAybPeUrqdz4veAucgnizPv8KqCog5/FQ0B3kL70w7osLyV0
         QVwYZlzXOwvShtLV3f9Yi5hwz+LJWduQo+gxOvfk=
Date:   Fri, 15 Jul 2022 16:12:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH 5.10 1/3] docs: net: explain struct net_device lifetime
Message-ID: <YtF14wpR9oBeb8dI@kroah.com>
References: <20220714161134.95034-1-pchelkin@ispras.ru>
 <20220714161134.95034-2-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714161134.95034-2-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 07:11:32PM +0300, Fedor Pchelkin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> commit 2b446e650b418f9a9e75f99852e2f2560cabfa17 upstream.
> 
> Explain the two basic flows of struct net_device's operation.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

If you pass on patches to others, you also must sign off on them.

Please do so for all of the patches in this series.

And why is a documentation patch needed for stable?

thanks,

greg k-h
