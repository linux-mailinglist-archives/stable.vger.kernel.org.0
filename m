Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EA161EE46
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 10:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiKGJJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 04:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiKGJJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 04:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64C9644E
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 01:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75BE260F1C
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 09:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A452C433D6;
        Mon,  7 Nov 2022 09:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667812181;
        bh=7FXwxCZk0btACnAHIbKZFC53N1N0QZlfJ1VG45FDwHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+V+V3prX1ImNTBpUALyn6hjBrs/PCF7OsN9rJIGB2OGevHvfhvsReXN2GDNQEoIT
         GHWJSkiD0eNNqzOHiJ34XnCZNq1Hn9XTYInQqkCoxorZZGZ6KUgRg9FU6cfxQAsh/o
         tiCSDgzWlNMklw4+N5t3aNFJyYios8H3iIiqI4rw=
Date:   Mon, 7 Nov 2022 10:09:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, kuniyu@amazon.com
Subject: Re: [PATCH 5.10 0/1] Request to cherry-pick 3c52c6bb831f to 5.10.y
Message-ID: <Y2jLSm9q12OeWikk@kroah.com>
References: <20221102194313.840129-1-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102194313.840129-1-meenashanmugam@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 07:43:12PM +0000, Meena Shanmugam wrote:
> The commit 3c52c6bb831f (tcp/udp: Fix memory leak in
> ipv6_renew_options()) fixes a memory leak reported by syzbot. This seems
> to be a good candidate for the stable trees. This patch didn't apply cleanly
> in 5.10 kernel, since release_sock() calls are changed to
> sockopt_release_sock() in the latest kernel versions.

Both backports now queued up, thanks.

greg k-h
