Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABAB52DAB7
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbiESQ4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 12:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242364AbiESQ4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 12:56:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C674A4FC52;
        Thu, 19 May 2022 09:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F2F2B81E94;
        Thu, 19 May 2022 16:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEFAC385AA;
        Thu, 19 May 2022 16:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652979366;
        bh=rmkXuKAuTCkGVXWPr370lgteCoNM54F/HnyfT4y0AGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vS0GV0hou4ePY2WEKK1sm71gnXDcK7cI6pBU00lMhvBtGgmvXEPeq/sZ//p74lWUi
         JtBEov3xLGjvA0FwK0+s/OSfoipWSpRIYVxaRMXGKVt7y4rpAS8c+sblr86sN3Csif
         0ZUGa/bIAZFHlyRYI1rBL41BkHAwr+8PAGxagRXk=
Date:   Thu, 19 May 2022 18:56:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH v2] nvmem: brcm_nvram: check for allocation failure
Message-ID: <YoZ2ozeju8bXzUyX@kroah.com>
References: <20220510093540.23259-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510093540.23259-1-srinivas.kandagatla@linaro.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 10:35:40AM +0100, Srinivas Kandagatla wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Check for if the kcalloc() fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: 299dc152721f ("nvmem: brcm_nvram: parse NVRAM content into NVMEM cells")

This isn't a commit in any tree that I can see, are you sure it is
correct?

thanks,

greg k-h
