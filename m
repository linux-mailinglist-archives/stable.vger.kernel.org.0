Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACD436081C
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 13:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhDOLUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 07:20:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56597 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDOLUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 07:20:40 -0400
Received: from fsav402.sakura.ne.jp (fsav402.sakura.ne.jp [133.242.250.101])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 13FBKFtS085702;
        Thu, 15 Apr 2021 20:20:15 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav402.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav402.sakura.ne.jp);
 Thu, 15 Apr 2021 20:20:15 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav402.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 13FBKET4085693
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 15 Apr 2021 20:20:15 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH 1/5] xattr: Complete constify ->name member of "struct
 xattr"
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Jeff Mahoney <jeffm@suse.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, selinux@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, stable@vger.kernel.org,
        zohar@linux.ibm.com, jmorris@namei.org, paul@paul-moore.com,
        casey@schaufler-ca.com
References: <20210415100435.18619-1-roberto.sassu@huawei.com>
 <20210415100435.18619-2-roberto.sassu@huawei.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <164b0933-0917-457e-4dad-245ea13cbe52@i-love.sakura.ne.jp>
Date:   Thu, 15 Apr 2021 20:20:15 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415100435.18619-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/04/15 19:04, Roberto Sassu wrote:
> This patch completes commit 9548906b2bb7 ('xattr: Constify ->name member of
> "struct xattr"'). It fixes the documentation of the inode_init_security
> hook, by removing the xattr name from the objects that are expected to be
> allocated by LSMs (only the value is allocated). Also, it removes the
> kfree() of name and setting it to NULL in the reiserfs code.

Good catch, but well, grep does not find any reiserfs_security_free() callers.
Is reiserfs_security_free() a dead code?
