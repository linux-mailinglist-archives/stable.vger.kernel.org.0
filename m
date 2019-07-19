Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF396ECA7
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 01:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbfGSXHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 19:07:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46787 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728747AbfGSXHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 19:07:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id i8so15056161pgm.13;
        Fri, 19 Jul 2019 16:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MWjZYC8fdMQNtbmG2vB97lJlxQXw6XI9YYU1MWaUobc=;
        b=jJdnOsgidE+l56Nps11TW0ttv3MyU96PPekJXtqkJdzISg3d8G2oiRL4PS25EuBnH0
         /iVQCzOuGPSom0c09M1ud2ze8P8In/2B7+0OwQdVESihc1KC5egyIqUH61msBNv3YBjU
         fdB8RvXHblNcoOoiEuGEMUwQ8ro4Dq/1idF1vvLUZU/IbwSx1SgkOsjfGg+b1vMoNgF8
         C0ntdextaEGcxpqjAYFo8z6CvH92BjGdcMh+b+VLFs4p0hVOeB1VCbKgbYjDGvYXITsd
         uLj9errxgM8dD+Y2YqGbJw3hiD3BMYoJdIgRCYP6akZz4Cuw2510NYPYTJwt7FMPvA6J
         MsRg==
X-Gm-Message-State: APjAAAXJXaSq64WIYJN9PdUSq+Y/QFkhMz0YoGF4sjSd1056wepn4zjI
        AMbAeIC67GEeq3jcAtpCwGTXyGxL
X-Google-Smtp-Source: APXvYqwKSWExaTmOAl7W0Q3HC86Qwbod8gNZZTZVJxAwLT4XvoHzVzA65+t4HdKHftj8cVXYp92kVg==
X-Received: by 2002:a65:6850:: with SMTP id q16mr19292928pgt.423.1563577651298;
        Fri, 19 Jul 2019 16:07:31 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id q198sm32702019pfq.155.2019.07.19.16.07.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 16:07:30 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 73C20402A1; Fri, 19 Jul 2019 23:07:29 +0000 (UTC)
Date:   Fri, 19 Jul 2019 23:07:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't trip over uninitialized buffer on extent read
 of corrupted inode
Message-ID: <20190719230729.GS19023@42.do-not-panic.com>
References: <20190718230617.7439-1-mcgrof>
 <20190719193032.11096-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719193032.11096-1-mcgrof@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 07:30:32PM +0000, Luis Chamberlain wrote:
> [mcgrof: fixes kz#204223 ]

This patch can be ingored for now for stable. It does not actually
fix the issue, just delays it a bit. Once I stress test over 1000
runs with some other fixes I have I'll send a new set of stable
fixes.

  Luis
