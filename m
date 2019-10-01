Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD9CC3FA9
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 20:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbfJASR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 14:17:57 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:37099 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfJASR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 14:17:57 -0400
Received: by mail-io1-f51.google.com with SMTP id b19so22374789iob.4
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 11:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4aZga3zUoylQ3yuiPnzhZnjQhiqfVb95E9ODTI6nN64=;
        b=Whx0S1D5CudF3N0nedeSigcE8yr420PYk2iM0UxuHQMzUh28qCldw2a9UuQflXaD+x
         ZxLWZKXtDeOyPiN7jng+9pTANTTGm2heiv/mpdMdHrWbcw/Jl77DfozLezSDlUjrjeAF
         KZCMQHqYJcj+sFgvM8Az2MdkDg2ViebexjsfTtf2ZN7Lm8y0mQOu37419O36DZJLbn+u
         z3oVZ6k7A7hf+cohvy8RE9vnvSiYAK6wgqKkvxugQUh0KW5u/RCIrbdJWXAkBfKpw1sO
         IFtawUQP32XHqjREKXWEoSvtC2r9cKbRkAIRE20+BcNPXzNU55slJrM9+GD6iuGdd/lk
         zvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4aZga3zUoylQ3yuiPnzhZnjQhiqfVb95E9ODTI6nN64=;
        b=WU04xX42BWqenHhfmzDl8zdN+3IpdcGVkQjd1qbXumXbc9chvkyrD6zyZ0RbZNMhrd
         n8DhzAs2OaOv+1IHDR8zYKJRA4zXcZ5+M9xX5y8SJQLCTINNN0U+pwrQNICeYAy05AhT
         kMurQGIc7ZMhHWeXAgiOYOHc1/6LxBRKbJOIm79FwDjPfy/4wT98jPzbglLvbggl9Uw/
         qbV+16l6qZ/6ingzErlUnwARlHtwsV/4GKe4Ir1jrPFL4YyMo5tIIVhAxA0sOkBVU4y1
         o66ZHehLH+Py+kcBRexZvx4Z9WeU3S5+xCxXgBi0zRkxUJjpUfQElDhlvWIqp8J1cH73
         xELg==
X-Gm-Message-State: APjAAAWO0GDj14TQuQpGPYiqoyuGv/Q992tRSBm+ArzYM+iqNOn1/dl9
        KLVerC6XiAZ/5gNzT0O3voL1rPao+3XcYH4AXVccSZYOIZ0=
X-Google-Smtp-Source: APXvYqy+4JqrpXpnITzx+ZaGiOezsjPjaaS4YBw4pPPxN0+eJri9q6LY/ha/VX3PPG6A/nr3SGpHMzqnayTBfqSJjuU=
X-Received: by 2002:a92:3f0a:: with SMTP id m10mr26377507ila.158.1569953876246;
 Tue, 01 Oct 2019 11:17:56 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 1 Oct 2019 13:17:45 -0500
Message-ID: <CAHCN7xJceePOGJW9UkPpe139rGx9vdOYkSd2e8jGoM9=TaoSCg@mail.gmail.com>
Subject: ARM: dts: am3517-evm: Fix missing video
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Could you please apply 24cf23276a54 ("ARM: dts: am3517-evm: Fix
missing video") to 5.2.y and 5.3.y

Thank you

adam
