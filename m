Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A03210ED
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 07:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBVGl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 01:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBVGlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 01:41:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B22A964E44;
        Mon, 22 Feb 2021 06:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613976044;
        bh=WE4SclRTuEtcQvOZekXbObVufr83p4gxIk17zbuFx6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MmEeZpW7oVXa67AqJdfDKUwetMVbdut2XeQ5tuwtv1q9BCJg9auBhfRRgSMLiIPrK
         4ajVfIk5VCeEz/Z+SsnhHh14590VGhliUZ45twivkpLZLebU0v+QU19JnWskGdEzhm
         4Y1uedduhJeF7CgSyFU4NNkwJ1pfwDS8an/it7TM=
Date:   Mon, 22 Feb 2021 07:40:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     stable@vger.kernel.org, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, lee.jones@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH 4.4.257 0/1] Bugfix for ad4740ceccfb ("futex: Avoid
 violating the 10th rule of futex")
Message-ID: <YDNR6dsqrAxUa6Jz@kroah.com>
References: <20210222040618.2911498-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222040618.2911498-1-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 12:06:17PM +0800, Zheng Yejian wrote:
> *** BLURB HERE ***

No blurb?  Why is this needed?

