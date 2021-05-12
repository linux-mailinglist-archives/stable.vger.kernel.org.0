Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60BA37B950
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhELJfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:35:38 -0400
Received: from foss.arm.com ([217.140.110.172]:35434 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhELJfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 05:35:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B65D1D6E;
        Wed, 12 May 2021 02:34:29 -0700 (PDT)
Received: from [10.57.30.129] (unknown [10.57.30.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE1033F719;
        Wed, 12 May 2021 02:34:28 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] thermal/core/fair share: Lock the thermal
 zone while looping" failed to apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org
Cc:     daniel.lezcano@linaro.org, stable@vger.kernel.org
References: <16206371483193@kroah.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <adaa4a86-19e6-f5a9-15d0-e52cf2e6be51@arm.com>
Date:   Wed, 12 May 2021 10:34:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <16206371483193@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 5/10/21 9:59 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I will create the backport patches for the stable kernels that you
pointed also in other emails:
4.4, 4.9, 4.14, 4.19, 5.4

It will take a while (1..2 days) for me to build and test them.

Regards,
Lukasz
