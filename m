Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799603FE613
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 02:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbhIAX0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 19:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237886AbhIAX0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 19:26:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E798C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 16:25:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d5so145253pjx.2
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 16:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=rcCA0g6hXsQMwl0K5iQmbwX1GzhHNblzx0cz7ybyTqo=;
        b=WY4OIVL8xEOYFr3S/lBeqlp7V+fo38pXBVxi59KKjEylxbvPVJiXd3Ge6cvxKUAy+v
         dRmNNaQ24BJe0BIlng604yPBqvvj6ef7IyhnCO7ToHKwqnvtbMgk3tXYV3Fl45Ae09Hp
         oltKkoQO5alSi06XVHRp5j2Jbnhwr2yTJLrkhz8d7Rf9CtcrBIrPLOLrOeHcL/wYnxzU
         vzwCQstW/bj9K/bTpEbPAZnryoen9CncHaQtbT2W+SrYKfA3ERCh2wC4SMyvpeDT2PUl
         ZTml/bwJGxUfy5OBK+QypTRPxMOM61UGnVfxz6xEakn31/76EA1wT6qjlUdQ4pgO3/S0
         2hmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rcCA0g6hXsQMwl0K5iQmbwX1GzhHNblzx0cz7ybyTqo=;
        b=E00XZGJht0ywlZDpRDiORomwm86oAOTzORzMOSf+KbflVpWQRy0vT7BQqqvkoXDMjf
         j51BpxmxdyVHmHjxFPw6lTBy3DBkLPqGRWtgFrcT5hLCEUDKDmcQxzRX9qsGooxPwjF4
         gylavIMLtwUqGKTLK7YZ9oe40uWtlk6yEnF754DXX3HDti1dBse5IiDFDiGoErC5lPyg
         XiP1klGReRGenh9+HDUgQEF7BjqWh+Cn5YnbJ7LjyMgZjWROYSEKoi6+DqTq1T7GrJb2
         HFpmLKTsxZIvODEvEJy9GnteqlB2U2Pkks0DOkpEEWZRWr0jX0Jtyn6nAfvMJw3I9oDs
         qKgg==
X-Gm-Message-State: AOAM531HvVvUq4vF1ksNHizxz+ca7/t/V4TIox4vZELuRVtTy5Oa0wLE
        xvxi8usIiBVSK0Mv8Zeft2+RuR0ruqhcsQ==
X-Google-Smtp-Source: ABdhPJxbWGA7EgDFqx+rDNmvdaGY6ATsOmSYgMVVXqiXqW3xc8y2bRPGT30g1VmUEd4w5R8Cqfa40g==
X-Received: by 2002:a17:903:408c:b0:138:d90d:d9e5 with SMTP id z12-20020a170903408c00b00138d90dd9e5mr151515plc.45.1630538738782;
        Wed, 01 Sep 2021 16:25:38 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:400::5:a2b2])
        by smtp.gmail.com with ESMTPSA id q4sm27616pjd.52.2021.09.01.16.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:25:38 -0700 (PDT)
Date:   Wed, 1 Sep 2021 16:25:37 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Linux stable GitHub mirror stale
Message-ID: <YTAL8S9qxfhsO/iG@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

https://github.com/gregkh/linux seems to have gone stale. The last
update was about 24 days ago. Do you know what might have happened
there?

Thanks,
Omar
