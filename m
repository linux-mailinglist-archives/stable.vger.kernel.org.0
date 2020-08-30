Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F85256E98
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 16:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgH3OXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 10:23:41 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:33592 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgH3OXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 10:23:41 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2020 10:23:40 EDT
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
        by mail.parknet.co.jp (Postfix) with ESMTPSA id C7EB31B44DF;
        Sun, 30 Aug 2020 23:16:37 +0900 (JST)
Received: from devron.myhome.or.jp (foobar@devron.myhome.or.jp [192.168.0.3])
        by ibmpc.myhome.or.jp (8.15.2/8.15.2/Debian-20) with ESMTPS id 07UEGaSQ331653
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 30 Aug 2020 23:16:37 +0900
Received: from devron.myhome.or.jp (foobar@localhost [127.0.0.1])
        by devron.myhome.or.jp (8.15.2/8.15.2/Debian-20) with ESMTPS id 07UEGapa3170565
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 30 Aug 2020 23:16:36 +0900
Received: (from hirofumi@localhost)
        by devron.myhome.or.jp (8.15.2/8.15.2/Submit) id 07UEGaYE3170564;
        Sun, 30 Aug 2020 23:16:36 +0900
From:   OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] fat: Avoid oops when bdi->io_pages==0
References: <87ft85osn6.fsf@mail.parknet.co.jp>
        <20200830140143.4332B206FA@mail.kernel.org>
Date:   Sun, 30 Aug 2020 23:16:36 +0900
In-Reply-To: <20200830140143.4332B206FA@mail.kernel.org> (Sasha Levin's
        message of "Sun, 30 Aug 2020 14:01:42 +0000")
Message-ID: <87v9h0nrqz.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.8.5, v5.4.61, v4.19.142, v4.14.195, v4.9.234, v4.4.234.
>
> v5.8.5: Build OK!

[...]

>
> How should we proceed with this patch?

Only 5.8.x has to apply this patch.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
