Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001C4542B6E
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiFHJYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 05:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiFHJWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 05:22:44 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC63D32342A;
        Wed,  8 Jun 2022 01:43:36 -0700 (PDT)
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.18 35/68] md: don't unregister
 sync_thread with reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654677814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zu6nKSkRxLEOxSVDZbtX8PO1w6q5KHD+W/v4musC33A=;
        b=H5QnT5HUH7i8I4gAKCsZqofCw7uMFdFdEJhP4nPR0tp4WLC2/3dlvGUguc9mf1qRLnV9QZ
        /LYpk8ZV7P947RRfgU9pGXQh1Sm7nK6HiURai4MDCl4JBHke5SnIs83HRgrmXK4Q8l3Xmb
        +5Sb45wpRmmdkpb3j0XS+b9d1reaLAw=
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, snitzer@kernel.org,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        dm-devel@redhat.com, Donald Buczek <buczek@molgen.mpg.de>,
        agk@redhat.com
References: <20220607174846.477972-1-sashal@kernel.org>
 <20220607174846.477972-35-sashal@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <f369ed06-d268-6fa9-f4aa-e9f5cd5ce53a@linux.dev>
Date:   Wed, 8 Jun 2022 16:43:26 +0800
MIME-Version: 1.0
In-Reply-To: <20220607174846.477972-35-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Pls drop this one from all stable kernel versions since it caused 
regression.

Thanks,
Guoqing
