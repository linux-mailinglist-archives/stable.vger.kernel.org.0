Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16A672855
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 08:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGXGfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 02:35:02 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41067 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 02:35:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so10332075pgg.8;
        Tue, 23 Jul 2019 23:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+/yujlyGoYXSoGcbOflZ27GWD5wEVIrP1vox+0cmyJo=;
        b=e0A5vncc1CtIsJFzzo3bkNOri9W6N5f0wG4RPxnsmOLIEJ7wyWvJ/FTL9d2/8A6lC4
         VlNu+4r9cKGJu6c32Y/3GQ/s+j49kR9O+VUifmbl8Awd9tbiwFH+kIa1KgTeElkTtiCz
         +3ImX6JFNN5KTEFMO6XWOql5TN1p4De2sq4P4yI88RgNiFZcf9yOjzvKUTaBYn5bZr36
         HAcmYlP0qTYecQOZKISWIwyLmQ/ptqGpmbJxadTfi41yEkOcko7QAXFa2o+zYw+O3x3m
         bPZXDqL8AXx1ZZzddedEN9Jbg53xUg7Yt7Vq2Xzj0Svqk7SZqzlJZIIwGxj63TS8XNRN
         S+LA==
X-Gm-Message-State: APjAAAVwtqyFfkksUPn2FjI/oAOe1nCE0xUMGJew3njETzyYPfJlagxF
        Iytc0lVByYqC384JpJzezHk=
X-Google-Smtp-Source: APXvYqw4HDheITs8qtg4CksKi24EFqfaGI8nEJ7CeWp3tV2tN2NPUYfqilXuIR3gplhf4ft/t649GA==
X-Received: by 2002:a17:90a:8a0b:: with SMTP id w11mr85593184pjn.125.1563950100954;
        Tue, 23 Jul 2019 23:35:00 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 135sm44484082pfb.137.2019.07.23.23.34.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:34:59 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 7CDE44046E; Wed, 24 Jul 2019 06:34:58 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 2/6] xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
Date:   Wed, 24 Jul 2019 06:34:47 +0000
Message-Id: <20190724063451.26190-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724063451.26190-1-mcgrof@kernel.org>
References: <20190724063451.26190-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

commit e2421f0b5ff3ce279573036f5cfcb0ce28b422a9 upstream.

This patch moves fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
since xfs_attr.c is in libxfs.  We will need these later in
xfsprogs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/{ => libxfs}/xfs_attr.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr.h (100%)

diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
similarity index 100%
rename from fs/xfs/xfs_attr.h
rename to fs/xfs/libxfs/xfs_attr.h
-- 
2.18.0

