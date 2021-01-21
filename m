Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5147B2FF3C4
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbhAUTFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbhAUTFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 14:05:06 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6971C061797;
        Thu, 21 Jan 2021 11:04:13 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2EC9922F99;
        Thu, 21 Jan 2021 20:01:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1611255684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIGZ7IHl3sy0Lk94N7kf+/WsHttuKwteT2zoVx5q/SA=;
        b=b6VHXC9qRDl74L3WjiKc5vZEaRIQr7+UfqoSAmgSwLjjWaWKFCtl78eShg0Ey5Cgwl5nJP
        tV+7UnIeycZlfWm8lM9SsgWYZvgrqB9OJ2jqilDTBHzc/5VLi9y6hGr1KV8Tc9agAAzXWw
        WrjbMSJcPsG5ksdBVpjp+t2KGPU25Gw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 21 Jan 2021 20:01:24 +0100
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] driver core: Fix device link device name collision
In-Reply-To: <20210110175408.1465657-1-saravanak@google.com>
References: <20210110175408.1465657-1-saravanak@google.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <10c82099cb39f176dde96c16d9cc6100@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Am 2021-01-10 18:54, schrieb Saravana Kannan:
> The device link device's name was of the form:
> <supplier-dev-name>--<consumer-dev-name>
> 
> This can cause name collision as reported here [1] as device names are
> not globally unique. Since device names have to be unique within the
> bus/class, add the bus/class name as a prefix to the device names used 
> to
> construct the device link device name.
> 
> So the devuce link device's name will be of the form:
> <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> 
> [1] - 
> https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> 
> Cc: stable@vger.kernel.org
> Fixes: 287905e68dd2 ("driver core: Expose device link details in 
> sysfs")
> Reported-by: Michael Walle <michael@walle.cc>
> Tested-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---

Greg, any news here?

-michael
