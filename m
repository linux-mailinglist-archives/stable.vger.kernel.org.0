Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C6441337F
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 14:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhIUMnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 08:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232736AbhIUMnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 08:43:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0426760EE7;
        Tue, 21 Sep 2021 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632228142;
        bh=EMxygGM6U7YA+7YzpB5RU9rW+gLxjvTNxnpYC1hUmq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mscxw2WvV+lrjSIs94oLU9esgOvV4HtGmr6LkBrrMwIJ41TTn5m1PzbSkjANmX7ge
         DNseszACbOhfqjlg5wifYqa8nbDe5XMQAKzMvcFZjIcWVxZNSvbcSj80crLj/8UKtz
         +0KBceRuM2Ibw8J9ksedDcC+kBSeqTycLMU1Ffek=
Date:   Tue, 21 Sep 2021 14:42:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/175] 4.9.283-rc1 review
Message-ID: <YUnTJg58SRVGMu5u@kroah.com>
References: <20210920163918.068823680@linuxfoundation.org>
 <20210921121010.GA1043608@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210921121010.GA1043608@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 05:10:10AM -0700, Guenter Roeck wrote:
> On Mon, Sep 20, 2021 at 06:40:49PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.283 release.
> > There are 175 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> > Anything received after that time might be too late.
> > 
> 
> drivers/net/ethernet/ibm/ibmvnic.c: In function ‘handle_login_rsp’:
> drivers/net/ethernet/ibm/ibmvnic.c:2530:15: error: ‘struct ibmvnic_adapter’ has no member named ‘failover_pending’; did you mean ‘failover’?
>   if (adapter->failover_pending) {
>                ^~~~~~~~~~~~~~~~
>                failover
> drivers/net/ethernet/ibm/ibmvnic.c:2531:12: error: ‘struct ibmvnic_adapter’ has no member named ‘init_done_rc’
> 
> drivers/net/ethernet/ibm/ibmvnic.c:2532:14: error: ‘netdev’ undeclared (first use in this function); did you mean ‘net_eq’?
>    netdev_dbg(netdev, "Failover pending, ignoring login response\n");
>               ^
> include/linux/dynamic_debug.h:142:37: note: in definition of macro ‘dynamic_netdev_dbg’

Thanks for this, offending patch is now dropped from the 4.9 and 4.14
queues.  I'll push out a new -rc2 with this removed now.

thanks,

greg k-h
