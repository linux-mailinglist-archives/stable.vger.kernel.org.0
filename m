Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398196EC08
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 23:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbfGSVXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 17:23:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32904 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfGSVXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 17:23:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so14706642pfq.0;
        Fri, 19 Jul 2019 14:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MjnV+fDBeK0NuiqNKqFZfMMCcNTnblIXO+Ee219jx0s=;
        b=R7XCn1LOAB9vaX8LvCuqdCmmnxXsieMLYxCbIfNWJeCzsEYb/MH7ecbuIRoREj5R7O
         jt1FHZYO3wxo0LQ6vAV5iCpx9CHz60bj00hL/Lrj/pzViiJEgZiB0ZWru2GpXglZsDiu
         Tv1/0xXtTrWO2HkmYXohbSpJBUuavEU4XACO+g43YQLRDMVkUiXytGg6Wy7yp/VFm0VI
         1TfXodMqjuv4jFFWbvC6xRa9EtM43m8oxBXL5k6Xi1SjJpZqeoqRP+N9z0Xxqhe1zCOv
         NCyivHWauUddoRcUT7M30HMrqXnFI8J1YOw1pN2hivjGsa/7fhp9CL+gPmREZ7dYG8GW
         Ueog==
X-Gm-Message-State: APjAAAV0t5+fW+ew/EI90LiRzWB9TZ+yUUYDQFWDycrTYqm8CZiqmcwC
        14DIyZTnW3Hf+1EHHMbFtgE=
X-Google-Smtp-Source: APXvYqw34Y6eCQJXf+6gFAthU395tWEvHKzq8IlLG4ga3VbPSHw6Ut+zarL2mlZy0r1eU3no9cizug==
X-Received: by 2002:a17:90a:d58c:: with SMTP id v12mr58969334pju.7.1563571382016;
        Fri, 19 Jul 2019 14:23:02 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 196sm34764213pfy.167.2019.07.19.14.23.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 14:23:00 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 29B67402A1; Fri, 19 Jul 2019 21:23:00 +0000 (UTC)
Date:   Fri, 19 Jul 2019 21:23:00 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't trip over uninitialized buffer on extent read
 of corrupted inode
Message-ID: <20190719212300.GQ30113@42.do-not-panic.com>
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
> From: Brian Foster <bfoster@redhat.com>
> [mcgrof: fixes kz#204223 ]

Sorry, spoke too soon, although it helps... it actually still does not
fix that exact issue. Fixing this will require a bit more work. You can
ignore this patch for stable for now.

  Luis
