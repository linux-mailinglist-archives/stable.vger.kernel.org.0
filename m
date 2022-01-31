Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4364A4055
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358278AbiAaKis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:38:48 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58589 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358274AbiAaKis (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:38:48 -0500
Received: from fsav116.sakura.ne.jp (fsav116.sakura.ne.jp [27.133.134.243])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 20VAcJTp027949;
        Mon, 31 Jan 2022 19:38:19 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav116.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp);
 Mon, 31 Jan 2022 19:38:19 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 20VAcBPt027920
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 31 Jan 2022 19:38:19 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f38cbf77-9a65-eb8e-1863-d4383951685d@I-love.SAKURA.ne.jp>
Date:   Mon, 31 Jan 2022 19:38:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: FAILED: patch "[PATCH] loop: make autoclear operation
 asynchronous" failed to apply to 5.16-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        hch@lst.de, jack@suse.cz,
        syzbot+643e4ce4b6ad1347d372@syzkaller.appspotmail.com
References: <1643625156194186@kroah.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <1643625156194186@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/01/31 19:32, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Please don't try to backport this patch. We are going to revert this patch
because of breakage for /bin/mount and /bin/umount users.
