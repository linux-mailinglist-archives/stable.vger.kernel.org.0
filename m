Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040E9164F5E
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 20:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBST6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 14:58:47 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:34279 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBST6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 14:58:47 -0500
Received: by mail-qv1-f66.google.com with SMTP id o18so779713qvf.1;
        Wed, 19 Feb 2020 11:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EE2YczNla8qcSD1v8Yhtpjh81Hi8Cqph0O/BaPLbCAQ=;
        b=G1xtQrA+Fl4T+NuvpjF24JE+In7qYLxIVbRiQPkhWMC1ygQS53vX7qgTSJMWTK1yAo
         Fnxy/LLZlO9YMHyqOehXXfantuBgsWk1g8kgrvnXyuidsDUdQsLyt1rTnOGIQwyLGuIU
         HGm7wU+lOgUaYtDAA5xrONZf4U02774D8cZPxqI2iptCYE32M4ji1gZOfi2bgXgdYCBm
         49/aFU3pEkkgxZlJBuLQR2S3S5uyUNHBH6Y8l7sc8MzEiiEgATMsMsbvswFymESb6z2f
         imR7csI3tgyJvoX49ybjwQDkDLW7BbsVmnemJTSEBOwtr8wfDCBflEPziuqtohqxBBCk
         3EGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EE2YczNla8qcSD1v8Yhtpjh81Hi8Cqph0O/BaPLbCAQ=;
        b=AWi1weQTcuulGOJmUEAjlqdalzW6J6+KOY6EQYrB/Sfik1giHPc7SHkr94ESHbKbQ/
         9Unz9VGCd8Z55sgWi6vz1IW8vrijNT92cP4Uoc8PRzS8ufr+aKKK3gqCkVL8ZOnh2x/b
         iSC/mGeEz7XatLdN9jHxp18RiS//MqlburLAPpX6BN9I4P00m9EvaU5zGfNK/t1s35af
         RSeeH/60iwTaLGSECLD/IrEc+5ln31F5KQVBPpcbUDGI7Bg5gaIg3GkLHAn1BdtWsC/6
         fKFxqusRCnMDkNTGLj8RQFSjO/GPMoqpyC3LsY+86oEnptjlqBMHZ3Pjcbl3Xx0HROxe
         VP8Q==
X-Gm-Message-State: APjAAAUzhOf/29Q8Er25Dl42Vah888hbJASj//57x3MLLFJHdQU4cJeN
        awH4cjV2eKvRqKKjMQes9ps=
X-Google-Smtp-Source: APXvYqxzp/p/uQ5OKuQzlRYvxU23dKiBTzDJThNZdRcJUJajNV++tcWXBL5KzKBvpWKSUDJ/qbow+A==
X-Received: by 2002:a0c:f24a:: with SMTP id z10mr22861156qvl.33.1582142326588;
        Wed, 19 Feb 2020 11:58:46 -0800 (PST)
Received: from andrew4.ggf2gnjfztzulbq0d1gogf4ope.bx.internal.cloudapp.net ([52.224.106.77])
        by smtp.gmail.com with ESMTPSA id j28sm368751qki.61.2020.02.19.11.58.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 11:58:46 -0800 (PST)
From:   Andrew Norrie <andrew.p.norrie@gmail.com>
X-Google-Original-From: Andrew Norrie <andrew.norrie@cgg.com>
To:     bvanassche@acm.org
Cc:     axboe@kernel.dk, jaegeuk@kernel.org, linux-block@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH v3] loop: avoid EAGAIN, if offset or block_size are changed
Date:   Wed, 19 Feb 2020 19:58:45 +0000
Message-Id: <1582142325-40880-1-git-send-email-andrew.norrie@cgg.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <898950e4-3759-c78e-dd5d-422af9f8c507@acm.org>
References: <898950e4-3759-c78e-dd5d-422af9f8c507@acm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Just checking again the status of this patch?
It doesn't look like it's made it into the kernel yet?

