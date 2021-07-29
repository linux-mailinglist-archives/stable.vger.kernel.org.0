Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC963DA1C8
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhG2LKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 07:10:23 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33718 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhG2LKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 07:10:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: aratiu)
        with ESMTPSA id 02B1F1F43DA0
From:   Adrian Ratiu <adrian.ratiu@collabora.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] char: tpm: Kconfig: remove bad i2c cr50 select
In-Reply-To: <20210728215346.rmgvn4woou4iehqx@kernel.org>
References: <20210727171313.2452236-1-adrian.ratiu@collabora.com>
 <20210728215346.rmgvn4woou4iehqx@kernel.org>
Date:   Thu, 29 Jul 2021 14:10:16 +0300
Message-ID: <87h7gdqstj.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Jul 2021, Jarkko Sakkinen <jarkko@kernel.org> wrote:
> On Tue, Jul 27, 2021 at 08:13:12PM +0300, Adrian Ratiu wrote: 
>> This fixes a minor bug which went unnoticed during the initial 
>> driver upstreaming review: TCG_CR50 does not exist in mainline 
>> kernels, so remove it.   Fixes: 3a253caaad11 ("char: tpm: add 
>> i2c driver for cr50") Cc: stable@vger.kernel.org Reviewed-by: 
>> Jarkko Sakkinen <jarkko@kernel.org> Signed-off-by: Adrian Ratiu 
>> <adrian.ratiu@collabora.com> --- 
> 
> These are missing changelog. I guess tags are added, and nothing 
> else? 

Hi. That is correct, I've only added the tags you suggested on the 
first patch, the second patch is identical.

Adrian

>
> /Jarkko
