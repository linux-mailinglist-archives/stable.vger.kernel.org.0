Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EF933B7D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 00:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfFCWi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 18:38:59 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:40611 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfFCWi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 18:38:59 -0400
Received: by mail-pl1-f174.google.com with SMTP id g69so7521700plb.7
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 15:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=8u/MkfhKv0F5HzscWxuw+zM0wwd/pLLybu8U6WcXWZ0=;
        b=CX0b/wqNZkPijbqVahQ1Wzim1tpHme1i5ghQ6ARAsyahaOF2IiOPfVh7S1g1NnEBY9
         +DzQ6GW2+uzIsaTbNnhA3myte0JkBczwFtIh8cqLr3tiKy53yuRUkzsFvSwKbem9gQoY
         MT1aDuqqxN+TEc0x5MSg2QN9Pu+5vJeANWI8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=8u/MkfhKv0F5HzscWxuw+zM0wwd/pLLybu8U6WcXWZ0=;
        b=DD8vibYqle1H9pKxg0hr1Oq/UAkxA4kYbd+Dd8phqMo0gWrI6cUv9MmanE13WDSWkC
         w7uPBr1N7Ru/+pezEzUMqEQtwu9I+ITAmX+Q4GAe1hl0+A5m0lOD8zOWHaOslRpY3MSj
         oHzFPVl/XDw4AoW04zjgAJen6cDgVcyKLgOGufKrh+bCL+2T1zLzxmwytAGY9/rv6rtm
         FKcksTiMu7JfddipO8j2hE8jZmzHyl3TYxlooRlRszEbk8W1x7UNwLtQu4RmLLWyQFx/
         faCVnNk6Yg5QD138rmhc2cijWpKS+beZnhrQmdsW/b9+/llouZoQRa4pYpW27Ofr5eDa
         32GA==
X-Gm-Message-State: APjAAAVGblTMoAXZ1lhvBty5KqZjWsty2gq4nv0C9rZAryyUqA5acPhl
        1QGMQEegC1FMDI7YzRL8uwt0H8jO+UU=
X-Google-Smtp-Source: APXvYqwTdT9OjlCxPQ33HjQ3BdGhHgyp35si3K7z/5x5J9Fk6BLXlUSz+tHq0HARdOHI/nCOrFAhRg==
X-Received: by 2002:a17:902:3064:: with SMTP id u91mr33261608plb.244.1559601538780;
        Mon, 03 Jun 2019 15:38:58 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id w1sm24137756pfg.51.2019.06.03.15.38.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 15:38:58 -0700 (PDT)
Date:   Mon, 3 Jun 2019 15:38:52 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        blackgod016574@gmail.com, ard.biesheuvel@linaro.org,
        dvhart@infradead.org, andy@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de
Subject: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1
 mapping code")
Message-ID: <20190603223851.GA162395@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
* 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")

Could the patch be applied in order to v4.19.y?

Tests run:
* Chrome OS tryjob


Thanks,
- Zubin
