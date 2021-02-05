Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39228311513
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhBEWXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbhBEOYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 09:24:08 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39255C061A2D
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 07:51:08 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y18so9260778edw.13
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 07:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=L2XL3v7XazpZgNvoQmE70CDFnSfVfiLzPVmOltxiy0U=;
        b=Ujep2yZWrxWJhqGujnNEwt/FmHH9CbnMN8t0j2qPVOp84ULHUPAX0Aoe6hngPTD2Kq
         odJGg6WC/OxwA+wJF0cxZdRUXf5Mk3NQ1DfUsj5sZgnzaBOGlxBOFb+skrymiro8FmYT
         Vd2+gK7E5FnImsi+pCjiEUQ+UwwcdIBrySgZxKlxrmeaXWy09/YeLAigQL9CKLnFc+fr
         yEoN2NoBzoSN+kosLTOG8csRuivxCurL+U+QfaoMdm5slSM9a47SFxCMsXr9Upib0CZ+
         bZiHZD8PhVT9j71/lPFbZpwaa9hS1wSXKLbOMy0TXb9w/MFi/SzlS2GGx6vTp81DSDRy
         ulhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=L2XL3v7XazpZgNvoQmE70CDFnSfVfiLzPVmOltxiy0U=;
        b=WGXbymJiKgamqsYJUxniCZqJFcFhsWyGCaVZMQNdWSlu57V7iUbaBFanywbnzvuYNn
         Fx2Ic3ZwrPJMMPm+qrHpBJHiSNj8igpamiMh+doZhJsHlZEDjXrQBnqhpN16x0DKh2G6
         JlQDOpY8PjuOhPravuQxyJcgZWS4CTep3K9EQc50cjYSHxdYlrPufWwwMZ/paWR4TWUN
         ClidtLDTQeSEzJu1jKW8DDoQKkpjd3OTOnzgJyV/2S0dMZs1iwZLkSmlk+Bru2/uobgx
         UUXgeLyU1EsLcVomppQUQddYOY1GLkkhcEWZdn3+jM9zYRtmXwk/gtLJ2hGvAUHhaO+5
         PqVg==
X-Gm-Message-State: AOAM5311sMyZXqhqORt3TZP/7QEORlcFr2ES0ZRe+4BDF6HaDVnUupJQ
        i33C2AXnym14Xs39CPykh7ZHure+xxiQtVQhze88d0wGieo=
X-Google-Smtp-Source: ABdhPJwmcjx4GHpRulRy/2r9H6fzzYnTQqfwdmWHyoPXhU/BEBaFUMQ7CZbp0m3DCHBgfSrRNlM5Nv7Z9gjcwA3clOc=
X-Received: by 2002:aa7:d648:: with SMTP id v8mr3992336edr.287.1612540266958;
 Fri, 05 Feb 2021 07:51:06 -0800 (PST)
MIME-Version: 1.0
From:   Dave Pawson <dave.pawson@gmail.com>
Date:   Fri, 5 Feb 2021 15:50:55 +0000
Message-ID: <CAEncD4esY38Z-Z9t=KOXriZczry7htCYfCh7+B=eC_kUds5miQ@mail.gmail.com>
Subject: How to help with new kernel?
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do you really want companies only?
If you detail how to install the new kernel
(and any other prerequisites) and if 'ordinary use'
is sufficient, I'm sure others would help.

regards

-- 
Dave Pawson
XSLT XSL-FO FAQ.
Docbook FAQ.
