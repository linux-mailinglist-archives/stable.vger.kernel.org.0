Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394204548FC
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbhKQOlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbhKQOlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 09:41:47 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7904CC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 06:38:48 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id bf8so6839167oib.6
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 06:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qltk7ffFPYr4IBitNGdjOOBgH02FdrSObsWfIPOR1g0=;
        b=FY6p6EwclHoJamyV77zcP67FtGavCj/O8k/DnxfP+oH+11NvM1YgFP8CuNQkz5dSjD
         0CZQv1nDtDNpV+/feO8ro0IsSNnAs/4DuDyelmS02HojlNTwvx6ynYFvZUyddNu+Pxas
         14PEh6rD0BCA2uBTtjzuzGSt2uXkPtUEp+1UEpzTyVL669eYnhcbkr8zuOM6nSbz+5OA
         +yasIaszAtMTl0LHRPMXql0xbhW1E9gZ+wIr8DxKbx8WOukdnqH8UINRS4PS5pFxktxY
         7MlqYr0AkFIyqM5N8lzfc1IEsacHDRKsm96uJWjKkqxl07iNM18n+dtg3jKCvpZrqojU
         GRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=qltk7ffFPYr4IBitNGdjOOBgH02FdrSObsWfIPOR1g0=;
        b=6KBH/BpstFPRm8d3O1gtPcCAwrilnKG+MfP0hHgQTwA/gv6X0QN+ZttIWBvq8htanI
         etw9ocuciUH4xSt1epGy6gk8Llukw8VRNy0zX+0U5s6iL1i3LcdTyYIFrlTi0NCQYGaD
         JUZ8O9f3ttQ3E5dboikh3+RM6zgU5adjTyHhpPOfCyDWad699psP4JbOmvc/FISe08uc
         WbLy/kuhnwgCDhDtMW/2v4XgLWelTJ1Xs21omsbJ0oy0zafxhYVFoTaROwby8xwSfA4o
         xWUpZACaYtPBhh7OVPMtWb9fqSoOTLtqwvT6tKGFemhylS8e8mWrSV3gnjan3mGmQl8W
         MXWg==
X-Gm-Message-State: AOAM530G2VNpCe3NFPDy3+hwV4KQRctKwNVk+dCQ3g6gpWyWS3quLb+6
        7xn9Khawatv6az7lx43yS2sDpI/zChc=
X-Google-Smtp-Source: ABdhPJw/pJ6McLTpiQgyYagnkPiR9PX9PZWW/g4n3ec5P985seZVbvMvoCMQBFQVJj/xDS+YRGr5Yw==
X-Received: by 2002:a05:6808:2396:: with SMTP id bp22mr137956oib.78.1637159927648;
        Wed, 17 Nov 2021 06:38:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c3sm206756oiw.8.2021.11.17.06.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 06:38:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 17 Nov 2021 06:38:45 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     wklin@google.com, mfaltesek@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Please apply commit 19221e308302 ("soc/tegra: pmc: Fix imbalanced
 clock ...") to v5.4.y
Message-ID: <20211117143845.GA3996107@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

We see the following build warning/error in v5.4.160.

drivers/soc/tegra/pmc.c:612:1: error: unused label 'powergate_off'

The problem isn't that the label is left-over, the problem is
that upstream commit 19221e308302 ("soc/tegra: pmc: Fix imbalanced
clock disabling in error code path") is missing in v5.4.y. Please apply.

Thanks,
Guenter
