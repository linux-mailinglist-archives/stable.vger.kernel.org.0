Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B9333BAD
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 01:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFCXCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 19:02:46 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:41572 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfFCXCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 19:02:46 -0400
Received: by mail-pf1-f181.google.com with SMTP id q17so11455530pfq.8
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 16:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=JBk6HRiVJ3rPGZQamPfiwghjYQ4wREdWP6rR9aW69Ew=;
        b=GJ0dPILY3ecPG7ptEwgHuRlnA+2ME4YB48+vjVLAom91EVqR0i9nmC+jQ8Jv/PsNHk
         1Y1fqwA4CvPyQ/BR0iefBda9VsdKYKoF/R3UVorH4R3SNgLc/pir7pSsySEewrn/1N2e
         yqmDdsgUJiXJWgbaAjbLHnU/8xhILgwqVpGQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=JBk6HRiVJ3rPGZQamPfiwghjYQ4wREdWP6rR9aW69Ew=;
        b=JrVKE/8D2zGzltc1EaBX8fE1j8mkapjbqY5H7++8TVoitaZv7lReNHkgKw/PhgConM
         S7WT+Iw7VpkLdV+2r3ioeBUN3Iz3dnCoHBSuAgsSLbD7uetx8/hMq5MH+sUdHm8YmEwx
         BS28U6ZW9ka5fyXPFrqCHKFwJ0mPi9rXRdrw7G7nqZx/lY1AAlcYXngJdddROCLR3oe0
         rrkaaZq8AJeTkVS0Fw82UPzJ3akOfJT8wFRZR78D+2t3Hw6MYPymJORiTy3osGEGDGtR
         XlXkAHQKLpq8UXwICBKpjxHWo9/pYDWrcgussK+wdCOnM5fG7c/vF9eR8jkKpKHYhU8T
         Vd/g==
X-Gm-Message-State: APjAAAVcapmcCCr2rRZzLVc7wpBcFHb4PwXbjkSHmSR+oDwA0SliHhF/
        beLqOZXK+pwKPmhscv27+vDb5hdnUA8=
X-Google-Smtp-Source: APXvYqx6jhAP68mAxBQMg1Hzoo2gV3AB9b1r6jI7U6Q9qs76nv4s3Y+AsXmLCTY7lmYinUazUfgJPA==
X-Received: by 2002:a63:b24:: with SMTP id 36mr27424233pgl.439.1559602965347;
        Mon, 03 Jun 2019 16:02:45 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id e4sm15517718pgi.80.2019.06.03.16.02.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 16:02:44 -0700 (PDT)
Date:   Mon, 3 Jun 2019 16:02:40 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        blackgod016574@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Subject: 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in
 ip_ra_control()")
Message-ID: <20190603230239.GA168284@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

CVE-2019-12381 was fixed in the upstream linux kernel with the commit :-
* 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in ip_ra_control()")

Could the patch be applied in order to v4.19.y, v4.14.y, v4.9.y and v4.4.y ?

Tests run:
* Chrome OS tryjobs


Thanks,
- Zubin
