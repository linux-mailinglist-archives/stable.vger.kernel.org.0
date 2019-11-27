Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927DD10AACA
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 07:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfK0Guh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 01:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfK0Guh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 01:50:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBA72070B;
        Wed, 27 Nov 2019 06:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574837437;
        bh=lfZhXu1ebmZ0LcDlWL3BPgBtFD5kDb2TxGZqbn3nVp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSfxhZaUfBtlbe3jKP7Tz15BObu+nwu5Icy0JdkZTijghSutBYE6RBqqKFfOOIT2j
         mVWcUzUq7S+r3qz4VqnjuMvUYUn+85BIIyYfkw9wV9kP09FLbX1PmKOvCPwUqb61oP
         ds8Xv1l5VyJJL/uz0qvdzALJ2knHmP1W+/NpHJd8=
Date:   Wed, 27 Nov 2019 07:50:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     stable@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: Linux 5.3.13 BOOT TEST: Compiled, Booted, everything OK.
Message-ID: <20191127065034.GD1711684@kroah.com>
References: <55294cee-5a17-bcd1-1014-b0f51c4360bd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55294cee-5a17-bcd1-1014-b0f51c4360bd@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 04:19:42PM -0300, Daniel W. S. Almeida wrote:
> No crashes and no new errors on dmesg.

Great, thanks for testing.

greg k-h
