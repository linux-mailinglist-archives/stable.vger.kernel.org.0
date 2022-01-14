Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55A748E2A8
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 03:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiANCr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 21:47:56 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:53893 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236152AbiANCr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 21:47:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V1mjE.D_1642128472;
Received: from 30.240.100.73(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0V1mjE.D_1642128472)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 10:47:53 +0800
Message-ID: <ddecc7b4-a686-4ed8-7369-f0005f08664b@linux.alibaba.com>
Date:   Fri, 14 Jan 2022 10:47:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] ima: fix reference leak in asymmetric_verify()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
References: <20220113194438.69202-1-ebiggers@kernel.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20220113194438.69202-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On 1/14/22 3:44 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Don't leak a reference to the key if its algorithm is unknown.
> 
> Fixes: 947d70597236 ("ima: Support EC keys for signature verification")
> Cc: <stable@vger.kernel.org> # v5.13+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

LGTM.

Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Best regards,
Tianjia
