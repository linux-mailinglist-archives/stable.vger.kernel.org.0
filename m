Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60DC96AFE
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbfHTVAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:00:35 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:43823 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTVAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 17:00:34 -0400
Received: by mail-pl1-f178.google.com with SMTP id 4so70145pld.10
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 14:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=w4FM5QqA3F9t265pH3jb2RLNWAFw4O7wZnw47uw5UDg=;
        b=nq0yoeKmKgxjJ+Ovui5j54LKKBJ6Y1FKA7FkFKbzqk/UNtq5SZFH9UUagO7PfubNx/
         5xtMMS+cCsjG/5prdxaiiaJ5dYWtghlKeEBK9Sl0Q8XW1R7bPxVeBFkYL9YexN6tGVhn
         NT/QQE+hpkdUBPFDugIrtHoC0tYHdRtYfRzTsrhDj0q8w6p0WKONHRMNcDXjbH3v7EPU
         m0rlQXu10XYFmDIyFvtR56zS+cx1lVnB4EyugYpGb15FSV6L8pkficUrg2LfIbWfU4KX
         XeXc4YPZSBdNZcOdmc/6aR/X1bLRBUevIx5g95hn1Ly5bUbW+Fx4sWB2dUFfze2HWxQ4
         Mz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=w4FM5QqA3F9t265pH3jb2RLNWAFw4O7wZnw47uw5UDg=;
        b=PO5lmyOmhAw6C+hnGIpEFhjcSKPlrNJyH3MfOaKzGkPPTFEuWhU1dB23G3tpMAbhNG
         wJNIHj86O51kAPmVQnD2pYwI1hWDVWYozgvHA9Ej83N8zabkvCkSLbvJNLOo6OIHDsbr
         mE0n3/hbh9813onQ9WUNqJtpxZhR5DrcipCSZRgfZM6t15NAtEeg9otmoUWoMTNxBgZu
         1qzuPRdQLHLhLh0F/nlSKpwdLS4kEugOJ9oRNH+1WK2tpSlTR0JrPYrYO/N7u1gdvZ36
         i7d+huP8U2BYS8o+lZ5/Uv5lNw0ZuNRrRmVc/g4Dj1BtAuTqtNFfMuatb9ydVOC5l5dT
         63oQ==
X-Gm-Message-State: APjAAAXFfnAx3BQ2uWyalWPztw+8N7vfuG4LkjAERsZgTuNYR5zkY26y
        UGOwZNT0rzPrnLtpP0/zspBKNio4V9plwk5hxj2MHKP0z4ohmQ==
X-Google-Smtp-Source: APXvYqzj9Wc1mUJkV94mikKHsy+8Rv+ud5nG5c72Jwkzs/IwAn35zeVU4vsgdqFD0bw7ni075Vcq6sM1u9CjtEpb50I=
X-Received: by 2002:a17:902:8484:: with SMTP id c4mr29390102plo.223.1566334832658;
 Tue, 20 Aug 2019 14:00:32 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 20 Aug 2019 14:00:21 -0700
Message-ID: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
Subject: Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
 prevent Clang from emitting libcalls to undefined SW FP routines") to 4.19.y
To:     "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
prevent Clang from emitting libcalls to undefined SW FP routines") to
4.19.y.

It will help with AMD based chromebooks for ChromeOS.

-- 
Thanks,
~Nick Desaulniers
