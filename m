Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF112C758
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 15:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfE1NHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 09:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbfE1NHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 09:07:15 -0400
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A8B20B7C;
        Tue, 28 May 2019 13:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559048834;
        bh=VzsVEvAq8tygdfW60cYWIE/ki7uCW1+/apdqUOSuWQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wpfMQIYFGZrdyT3fQtUyVjvw6NFoIuXtKC17QpRelWavVqviih0DqBkDVq4fXJeyd
         19DVu/6It2VvRlpGjP9F+e3M8cOq2bkUIa/6necEESWkNG5NJGtp1ZuSOP7NdV4fPN
         b5hB30Bt4cPtV+avmZkyQA7UincopzDe7XQGH83U=
Date:   Tue, 28 May 2019 15:07:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kernel@collabora.com, Dan Carpenter <dan.carpenter@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@vger.kernel.org
Subject: Re: [RESEND PATCH] PM / devfreq: Fix static checker warning in
 try_then_request_governor
Message-ID: <20190528130703.GD6104@kroah.com>
References: <CGME20190313122310epcas4p4152c2c30d7a2971e44ddc7c5b64b7744@epcas4p4.samsung.com>
 <20190313122253.24355-1-enric.balletbo@collabora.com>
 <4535a997-e583-da83-0cdd-0433dd798f50@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4535a997-e583-da83-0cdd-0433dd798f50@samsung.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 10:15:59AM +0900, Chanwoo Choi wrote:
> Cc: stable@vger.kernel.org
> 
> Dear all,
> 
> It missed to send this patch to 'stable@vger.kernel.org'.
> So, I add it to mailing list.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
