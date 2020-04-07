Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB91A0EE6
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 16:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgDGOJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 10:09:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47520 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgDGOJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 10:09:43 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jLov5-0006yk-TB; Tue, 07 Apr 2020 16:09:39 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7A0E9101303; Tue,  7 Apr 2020 16:09:39 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Andrei Vagin <avagin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ucount: Fix wrong inotify ucounts in /proc/sys/user
In-Reply-To: <20200407121814.26073-1-jack@suse.cz>
References: <20200407121814.26073-1-jack@suse.cz>
Date:   Tue, 07 Apr 2020 16:09:39 +0200
Message-ID: <87o8s3jskc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jan Kara <jack@suse.cz> writes:
> Commit 769071ac9f20 "ns: Introduce Time Namespace" broke reporting of
> inotify ucounts (max_inotify_instances, max_inotify_watches) in
> /proc/sys/user because it has added UCOUNT_TIME_NAMESPACES into enum
> ucount_type but didn't properly update reporting in
> kernel/ucount.c:setup_userns_sysctls(). Update the reporting to fix the
> issue and also add BUILD_BUG_ON to catch a similar problem in the
> future.

Just merged that:

  https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=timers/urgent&id=eeec26d5da8248ea4e240b8795bb4364213d3247

Could you please send a patch with just the build bug on ?

Thanks,

        tglx
