Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0507374D3
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfFFNIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfFFNIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 09:08:04 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19EE32070B;
        Thu,  6 Jun 2019 13:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559826484;
        bh=gOuzaLWUCW6HTFIVZRdQHch3nZQ8j2jksO2B1phJekQ=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=xlrPvCU0UBIJMoxUiUh74KuS9CBqjzb3ZkFrrcGZNJAPtKRDkpQmOS3IxWKX9h0ir
         boJPrHyL20moUuZz8KeEDjnMTNweOgjRwwPi6kN7XkKTgPxzTM+J01S+X1TNHoq5HM
         msmwHvZoUx1YLsgGHlP22+rIN2WAThy7xiHBiGq0=
Date:   Thu, 06 Jun 2019 13:08:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
To:     linux-rdma@vger.kernel.org, linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH RFC] svcrdma: Ignore source port when computing DRC hash
In-Reply-To: <20190605121518.2150.26479.stgit@klimt.1015granger.net>
References: <20190605121518.2150.26479.stgit@klimt.1015granger.net>
Message-Id: <20190606130804.19EE32070B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.1.7, v5.0.21, v4.19.48, v4.14.123, v4.9.180, v4.4.180.

v5.1.7: Build OK!
v5.0.21: Build OK!
v4.19.48: Build OK!
v4.14.123: Build OK!
v4.9.180: Build failed! Errors:
    net/sunrpc/xprtrdma/svc_rdma_transport.c:712:2: error: implicit declaration of function ‘rpc_set_port’; did you mean ‘rpc_net_ns’? [-Werror=implicit-function-declaration]

v4.4.180: Build failed! Errors:
    net/sunrpc/xprtrdma/svc_rdma_transport.c:635:2: error: implicit declaration of function ‘rpc_set_port’; did you mean ‘rpc_net_ns’? [-Werror=implicit-function-declaration]


How should we proceed with this patch?

--
Thanks,
Sasha
