Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE4222F8AC
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 21:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgG0THh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 15:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgG0THg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 15:07:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C28C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 12:07:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b127so4737768ybh.21
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 12:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to;
        bh=LiiKCPr2QyINYoQyygLu7UNTVJxt9dry1MObvfbEeRg=;
        b=SAsZDZGuu3SNNqmzSWG7EOWNBNLYARLUDdZfFtfYmKTR/5zfwwGh4VMq/tTz1vrlPN
         /Sg1JdySM6DwXNKx8DuBF9sTjwGN9HftWvD/bht/USUYRgwt3qytcB6oUbu4CjJnRASM
         TFp+0FuJBw/FoqRnC+nTCEDzJbG78o+2A6HYqrKyHgbcRkh7EAEzLBQ1NCyE/R6YboEO
         A6D4DKIeQpFYFSXWg7w6hLx9UTlh2CR1XpxqCMX8PSmyb66F4T8CgAqggokLCL8z2FyN
         iNnVboB0zsOyX3jFYzg16UCI+5+tXViz0eF4nDdzwyp51/ngmccnLcsXvIT4HCtTtIx1
         3pYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to;
        bh=LiiKCPr2QyINYoQyygLu7UNTVJxt9dry1MObvfbEeRg=;
        b=W8iQbfMuCN2qu+bsIqzO/QvZOW8WSw+YtJ3NpoMD+V7RUNUti5Ui8ajIGJH41m6Yu2
         POtSXfx9tuilAJ7wsCtkEqAyF2j9gLezaKELqMVqyKZq+LfWtBSh3dBdico9RhkNMMH9
         2sE3m6WgFHwUp7qDAjd3K3XjIDu9Je8yWMx9Cq2RNCcH6iuPCdmKH1Ge5Pn9GBcjcOVO
         3kYclcx19l3xfbBqbcxTCcWwMGQNey3dAi0nq4+DU80DllPGRJ9WnOCHsM+mWE8NqMIo
         Tb0rNSONMFMtE9/PEHFjkIIR5NfhVpEf7D+IGuNiW/2jO+KaEkEATFbwnM2RIkSGm/mk
         s2OA==
X-Gm-Message-State: AOAM531UmMkROoXTgoIqnjxZNCj48CMFU8queTjAXo9bT4RcJ4YYlRpV
        8gx3kq1z5k2dp91o4DKC7IO3UTsiXhsjNj7CZoq8bAWTxX4HOe6GmVs2yiG9Wwe5nNSr6IbbLI8
        n5iX+S3ZWxPvTNYbmISXAqYVwgsIG1yjbgqAUqb8nAuBAl8QQ2R+SI5OX/pVFZKlwQQoldBJyju
        Q5mw==
X-Google-Smtp-Source: ABdhPJzARIKfbeQJAuFZYEj6fyO3YyxWmxcvjhMs/7kbcl7xI/xrOVxaVvJGKcsKpYSvbMCQyWEab8XrEGMlMfuTKcs=
X-Received: by 2002:a25:7908:: with SMTP id u8mr17674493ybc.144.1595876855883;
 Mon, 27 Jul 2020 12:07:35 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:07:29 +0000
In-Reply-To: <20200727175720.4022402-2-willmcvicker@google.com>
Message-Id: <20200727190731.4035744-1-willmcvicker@google.com>
Mime-Version: 1.0
References: <20200727175720.4022402-2-willmcvicker@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: Re: [PATCH 0/1] Netfilter OOB memory access security patch
From:   Will McVicker <willmcvicker@google.com>
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding stable@vger.kernel.org. Please see the original message regarding this
OOB memory access security fix. The patch is intended for the LTS branches
4.19.y, 4.14.y, 4.9.y and 4.4.y.

Thanks,
Will


