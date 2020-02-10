Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B9B158212
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBJSIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 13:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgBJSIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 13:08:22 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8A720838;
        Mon, 10 Feb 2020 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581358101;
        bh=DEXq5wEyTnKzAulqv7FisQGeT3i3LrErRIJAxW26UYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0chwakTDG2Fu9dNp72f+zQL6rGUPAkxX7ihMdP/34jj8EKyD0rgvO12T6Yw3vO9UY
         dB9NJ3eO9o0nDPBgF2W8sv7EYORe0QLpf2FH/ghbINLPHg8HoEj0iZbKSamhOkmNdr
         u6UMCNbI8lkuUXiB+gx1f8JgXmIBUP4CKZSJkH8c=
Date:   Mon, 10 Feb 2020 10:08:21 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/367] 5.5.3-stable review
Message-ID: <20200210180821.GA1030265@kroah.com>
References: <20200210122423.695146547@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 04:28:33AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.3 release.
> There are 367 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.3-rc1.gz

-rc2 is out to fix an arm64 build issue:
 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.3-rc2.gz



