Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7ED5F38E7
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 20:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKGTnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 14:43:46 -0500
Received: from ms.lwn.net ([45.79.88.28]:39272 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfKGTnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 14:43:46 -0500
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id BDD772C1;
        Thu,  7 Nov 2019 19:43:45 +0000 (UTC)
Date:   Thu, 7 Nov 2019 12:43:44 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Masanari Iida <standby24x7@gmail.com>
Cc:     linux-kernel@vger.kernel.org, mhocko@suse.com,
        ebiederm@xmission.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-doc@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH 1/2] docs: admin-guide: Fix min value of threads-max in
 kernel.rst
Message-ID: <20191107124344.14b8f01e@lwn.net>
In-Reply-To: <20191101040438.6029-1-standby24x7@gmail.com>
References: <20191101040438.6029-1-standby24x7@gmail.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  1 Nov 2019 13:04:37 +0900
Masanari Iida <standby24x7@gmail.com> wrote:

> Since following patch was merged 5.4-rc3, minimum value for
> threads-max changed to 1.
> 
> kernel/sysctl.c: do not override max_threads provided by userspace
> b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Both patches applied, thanks.

jon
