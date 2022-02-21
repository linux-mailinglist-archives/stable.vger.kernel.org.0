Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C781D4BE99E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiBUSHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:07:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiBUSFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:05:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BB3205F8;
        Mon, 21 Feb 2022 09:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0B2FB816FB;
        Mon, 21 Feb 2022 17:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940FCC340E9;
        Mon, 21 Feb 2022 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645466210;
        bh=/bqSQGgV3rlIjR9f2f/OKnzHeVuJZrktFRktG8NBOtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V//bSszrZj0ChfQgkk5cUZShnihdqnScflEZUKQpdH5WFl6qRxJIuqDdnw7UHqDoZ
         EzQ1oMqyvByAR1bOa8peu9rxcCId4LzohhOaGsSiV7zcFnAfeS1Y4neZ8YtoN/Y/Nu
         gbBkJljU2bwaGyUIvfalPvv/f0HEFrghFZMNlCVY=
Date:   Mon, 21 Feb 2022 18:56:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
Message-ID: <YhPSX1/DbOcFPjnQ@kroah.com>
References: <20220221084934.836145070@linuxfoundation.org>
 <0ceb2013-061c-700f-c386-3b180a96d59a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ceb2013-061c-700f-c386-3b180a96d59a@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:17:51AM -0800, Guenter Roeck wrote:
> On 2/21/22 00:46, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.16.11 release.
> > There are 227 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building mips:malta_defconfig ... failed
> --------------
> Error log:
> net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
> net/netfilter/xt_socket.c:224:17: error: implicit declaration of function 'nf_defrag_ipv6_disable'; did you mean 'nf_defrag_ipv4_disable'? [
> 
> Inherited from upstream.

Ah, fun :(

I'll leave this for now, it's "just" a Kconfig dependancy issue.  Does
upstream know about it?

thanks,

greg k-h
