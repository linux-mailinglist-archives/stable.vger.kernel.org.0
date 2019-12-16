Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98976121EF4
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 00:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLPX2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 18:28:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34428 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfLPX2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 18:28:48 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1igznB-00006O-VX; Mon, 16 Dec 2019 23:28:46 +0000
Date:   Mon, 16 Dec 2019 23:28:45 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, Andrew Price <anprice@redhat.com>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/12] fs_parse: fix fs_param_v_optional handling
Message-ID: <20191216232845.GP4203@ZenIV.linux.org.uk>
References: <20191128155940.17530-1-mszeredi@redhat.com>
 <20191128155940.17530-3-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128155940.17530-3-mszeredi@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 04:59:30PM +0100, Miklos Szeredi wrote:
> String options always have parameters, hence the check for optional
> parameter will never trigger.

What do you mean, always have parameters?  Granted, for fsconfig(2) it's
(currently) true, but I see at least two other pathways that do not impose
such requirement - vfs_parse_fs_string() and rbd_parse_options().

You seem to deal with the former later in the patchset, but I don't see
anything for the latter...
