Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B200747C561
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 18:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbhLURuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 12:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240617AbhLURuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 12:50:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081E0C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:50:00 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id n15-20020a17090a394f00b001b0f6d6468eso3281925pjf.3
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=3WuOUCrryImJbXB2WCBkwFWt0FxwBfpNH17/pgACY+I=;
        b=lzeR3Yutyko4ue6zpPRkYnHeFeYHkYhWi2HXhnFmwSgZoxDqIWPVRvClbdjrhYxlqn
         rRahbnj/TAVnUbFIZ5ENChl6PjdsnrepASDPJ0J+xwwmq3H6g2ou/kb8zCAu9NT5BpcJ
         AMRyX0brEuACkdB8QksmLYwkAdoPookmljTV4+EfHYsniKZtEo1234IFaB5yzc+CWhxQ
         OwOmjoLU/E4dLwsuyrRgBHGan/brF3xaE+/E286jLvJBjSMuJL743L/Lb8sIryR7MxlT
         niHZqijpYCCz8wNg03eafr8zUD9MJpp9X9ERSgFOzxbstw7c4dgSGX6DkTGENKuHdgPz
         Ti4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=3WuOUCrryImJbXB2WCBkwFWt0FxwBfpNH17/pgACY+I=;
        b=KbeDknHvCrJraTDta4mjvUXhl+h1dEOlHR6QeI6lg9zlPA4yeWvfTKEWnDQDtbOmN0
         NRKCrHBsV8qJnTYB5KsyM+vpoRWMs4d/X+mKDsRJGxll4NS7NLWbsqVJSk9LYubHX0W9
         zHZ3YOISJmbmpOi9Y6CutQOitetz5ElqenFvdvy+qdJY8LEEhMFXPSizA/ZmAb6WOskf
         4S6Jg1ci0eEcBQb5FsBUqZV03capwFEY6h1EPy7i0ZwO4xys8/fx4pDBuWuF08ccGGhu
         qTKgilsu8GFsuQAHHoRCoa/YQgloZb5NoQ40hKma3lEclg5CMB67nHuYhFBwxVpaqcro
         0wcA==
X-Gm-Message-State: AOAM53165mk1O7bovE5NvB1IQFP8duXimmcVfL5W+WutFDT/vQlolF7+
        +BOpPJYWuDktzkj5syg1ZH3TqYDZn4anKA==
X-Google-Smtp-Source: ABdhPJz0vVis2VVtEM14U7c9o8vJIaGgVJcvJ/qH5SNZxuL1Nnj3X2DTNXCe4nbmVVnFrHUj8U8NEA==
X-Received: by 2002:a17:90b:1b04:: with SMTP id nu4mr5396994pjb.72.1640108999342;
        Tue, 21 Dec 2021 09:49:59 -0800 (PST)
Received: from devoptiplex ([70.102.108.170])
        by smtp.gmail.com with ESMTPSA id d3sm14051739pfv.192.2021.12.21.09.49.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 09:49:58 -0800 (PST)
Date:   Tue, 21 Dec 2021 10:49:57 -0700
From:   Greg Jesionowski <jesionowskigreg@gmail.com>
To:     stable@vger.kernel.org
Subject: Hardware IDs patch, requesting add to stable 5.15.10
Message-ID: <20211221174957.GA3233@devoptiplex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

original patch subject: 'net: usb: lan78xx: add Allied Telesis AT29M2-AF'
upstream commit: ef8a0f6eab1ca5d1a75c242c5c7b9d386735fa0a
requested kernel: 5.15.10

Hello, 

This patch adds hardware IDs for an Allied Telesis USB Gigabit ethernet
device. People with this device that want to use it need to
apply the patch manually right now. 

Next time I'll know to add a Cc: for the stable list when a patch is first submitted. 

Greg Jesionowski
