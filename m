Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D791B4159BF
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 10:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239758AbhIWIGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 04:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237451AbhIWIGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 04:06:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 753936109E;
        Thu, 23 Sep 2021 08:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632384303;
        bh=+MUcDaRauyoZr0zXBCwHzF9N6GWx8r0/z+wnSzjd1nY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gYNos9wn7K206ij9GbNi5JAKjJ9HsM9x4OcuLbORT3a4AQicvliAxs+/LJGYc8t7s
         3hcnS7Bekw6jFIpI3CUnujf0hTzy91pHcqxlu6A4c2KjVDo+SU1/sJl8cN8YspLbI2
         Ri22mCDUnBR81Jdnnagi6zkGi7KJtC/829dpbWMI=
Date:   Thu, 23 Sep 2021 10:05:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cheng Chao <cs.os.kernel@gmail.com>
Cc:     labbott@redhat.com, Sumit Semwal <sumit.semwal@linaro.org>,
        arve@android.com, riandrews@android.com,
        devel@driverdev.osuosl.org, stable@vger.kernel.org
Subject: Re: [PATCH] [PATCH 4.9] staging: android: ion: fix page is NULL
Message-ID: <YUw1LFGXYUcZIlJZ@kroah.com>
References: <20210911112115.47202-1-cs.os.kernel@gmail.com>
 <YTyY6ZALBhCm47T6@kroah.com>
 <CA+1SViD_my-MPyqXcQ2T=zxF8014u6N-n2Fqcbi9BJPfo3KaTA@mail.gmail.com>
 <CA+1SViA9PN_uoykBtjukYGd-09=peWFCB147iSNnUMwtoT7b0w@mail.gmail.com>
 <CA+1SViDzyAsbQu7S+qKgLR7vS3wmA+MbQWZhV2rzdbLiFnxvsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1SViDzyAsbQu7S+qKgLR7vS3wmA+MbQWZhV2rzdbLiFnxvsg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22, 2021 at 08:17:15PM +0800, Cheng Chao wrote:
> I notice that v4.9.283 has released, but this patch is not merged.
> It's exactly a bug.

Can you please resend this and include all of the information in this
thread in the changelog comment explaining why this is only needed for
this one branch?  Trying to piece it all together on my own doesn't work
well :)

thanks,

greg k-h
