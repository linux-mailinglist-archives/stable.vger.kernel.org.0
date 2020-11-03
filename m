Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5B82A571F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgKCVgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbgKCVfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:35:54 -0500
Received: from gmail.com (unknown [104.132.1.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38C2F2236F;
        Tue,  3 Nov 2020 21:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604439354;
        bh=9EysiTj62kwvzsznrImpMePLN1JpkJD+UQs45RvI6aI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dIQDKYJ+HIJ777TQ77OiaSzRC1JZIYYfv8zZmUi1t0MmhyWgJ5hT63EsmPNkwmLgk
         zMYuNw/tgFwQ8uCM+SN+DBin5IR6soZifKjwy+m5b2vAroS6VXiljMBwC2xOodQsDw
         eBwKcDBfBt4pknUnB4Fye314hTQ480ZMz9fy/5Ls=
Date:   Tue, 3 Nov 2020 13:35:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
        Theodore Tso" <tytso@mit.edu>
Subject: Re: [PATCH 4.19 034/191] fscrypt: fix race where ->lookup() marks
 plaintext dentry as ciphertext
Message-ID: <20201103213552.GB394971@gmail.com>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203237.143516712@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103203237.143516712@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like something went wrong with formatting the email addresses that receive
these emails.  The Cc line has:

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,        Theodore Tso" <tytso@mit.edu>, Eric
        Biggers <ebiggers@google.com>, Theodore Ts'o <tytso@mit.edu>

The list addresses are part of display name of "tytso@mit.edu", so they
apparently didn't receive this email.

- Eric
