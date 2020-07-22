Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD422A0D4
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 22:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgGVUjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 16:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVUjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 16:39:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E341D20709;
        Wed, 22 Jul 2020 20:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595450363;
        bh=cSAkTV0rvULhkTDYAX0TFBSOxsananBIFa2o9Sm6ws0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dDsnccgjqcnfdMAevRrkt46qhSMjpfmNtb86JnoDvK8p/Xu/3EfXpu3Z2ntEJO++3
         zQRzJz4LnrfRldR33CQ9o2xECi/+tIOTb+rQVw1CgDU04GPz+D925ZGcFqK+9BZ8z2
         6THDxiaZwU94XRx26nK+XXO/CQEHQwz7ElsZs6vQ=
Date:   Wed, 22 Jul 2020 16:39:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel@collabora.com, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, krisman@collabora.com,
        Nikolaus Rath <Nikolaus@rath.org>,
        Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 5.7 1/1] fuse: fix weird page warning
Message-ID: <20200722203921.GD406581@sasha-vm>
References: <20200721185459.103445-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200721185459.103445-1-andrealmeid@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 03:54:59PM -0300, André Almeida wrote:
>From: Miklos Szeredi <mszeredi@redhat.com>
>
>commit a5005c3cda6eeb6b95645e6cc32f58dafeffc976 upstream.
>
>When PageWaiters was added, updating this check was missed.
>
>Reported-by: Nikolaus Rath <Nikolaus@rath.org>
>Reported-by: Hugh Dickins <hughd@google.com>
>Fixes: 62906027091f ("mm: add PageWaiters indicating tasks are waiting for a page bit")
>Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>Signed-off-by: André Almeida <andrealmeid@collabora.com>

Queued for 5.7-4.19, thanks!

-- 
Thanks,
Sasha
