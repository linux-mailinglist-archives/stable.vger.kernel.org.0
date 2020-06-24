Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08B72079E0
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 19:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405231AbgFXRGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 13:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404208AbgFXRGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 13:06:21 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7639C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 10:06:20 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h22so1408023pjf.1
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 10:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=O3VonQ07cK8IJdfGsrGKFAoaxeb2KC7a93KG4Y3gwWY=;
        b=XEoYUX91KbDKmDJH2LrdjcihUWISmDJ3iWxoOvoTTAeMimaieNziwMoiJW1+IJGIBa
         u9J0BjWFb4ttTyvl27B2/MYuufMyk4s5vfedfEm5QM4uI64QbQMdc89SlSiN5ujY1GGQ
         vL/POGoD2A0Qtzk0B6FLGsV9hIBp/HvoAYCiF8Q014naraga1xaf4wyEtl9r7G0vpt0G
         RSAzh59tMnOulJObEXwI22QAHEAAhMSDNjN3iNDqNgdUwC2pPn4YNSrV7fd4jBsz54XV
         sNOUV80aORz6f6O9GGJYqVH2zqc84W/fX5T6SPZbxkFAy2yWoiUHcuhOFoFmEtEg3Dd9
         b99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:content-transfer-encoding
         :user-agent;
        bh=O3VonQ07cK8IJdfGsrGKFAoaxeb2KC7a93KG4Y3gwWY=;
        b=ZQxhFit0jFzDwiSxvlc1cNTcpwQKeUD8kCeebIHgUFa+wr45zagI2krZrRBkqH7ELy
         O6jSbwTpU4TH8HrPOai+QQRtpjY8M5AhyJJCjsAEZpQ64OauL3QE6v7X4152o+GA7rz7
         uMC9HV2lfGfPbUoKv3Y5b967T+jchQtZtwtmZEsPMvejfhZeeO23aiOG0/7ty6LFgWEK
         LAvyScdRPSowFXGvqt4UqwLYnJR71+JW5eBReAmOKPLad89pK2nfK1XCQtsXSDcT9Dsc
         9fZ11OwX+rCFLKvx+U/Z1xRaKMMgQBCtWLOPFxswZrzK0Cdid7FrfozSOO/0k9EXrj1x
         1kIg==
X-Gm-Message-State: AOAM531lheE1z4t08B/+bS4h7WQmaXeyzFOALDRvBDHdomEsvE51SJZ/
        GxKdd4fJvNlHSxBNjqwgZdtA2OCP
X-Google-Smtp-Source: ABdhPJyRlf6x5S524JfAxzG8UzWVhYr/Y/0lwT/rvxOHU3opHSVd28jMljyFzfsq5M0qezfVeejY7A==
X-Received: by 2002:a17:90a:2683:: with SMTP id m3mr29510194pje.196.1593018380192;
        Wed, 24 Jun 2020 10:06:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s98sm6018246pjb.33.2020.06.24.10.06.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2020 10:06:19 -0700 (PDT)
Date:   Wed, 24 Jun 2020 10:06:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: v4.4.y.queue build failure (powerpc:defconfig)
Message-ID: <20200624170618.GA217333@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

powerpc:defconfig:

arch/powerpc/platforms/pseries/mobility.c: In function ‘post_mobility_fixup’:
arch/powerpc/platforms/pseries/mobility.c:330:2: error: implicit declaration of function ‘read_24x7_sys_info’

Guenter
