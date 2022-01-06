Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9610A4862B2
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 11:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbiAFKJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 05:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237626AbiAFKJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 05:09:22 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417F2C0611FF
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 02:09:22 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id w13so5814533ybs.13
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 02:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xVn1wMxF612KR4qd3v/+ZpMRoNnQHSmut43e76ryAy0=;
        b=ITSjOINvJbz26cSYFmAJMgjh4BRfFhbRo6wnwy0w0oE9bLf+0Y2t4VJqDY8S3TZxNS
         b8sJa7FA2RctFBONM7abZ6GuQ1ycd8lspdoyzuqWJplZYmksStuzrrUslLTN5S25KFtr
         nq1ZBnDqaKYx8p48IzPaRC7vqJfa3wYXIRUpl2VppdcvoEuG94LeC+TdL4G5OzFCAiYC
         nTtuwmfVXH3+c1fy2EvQtpoPX60Lwa6nHOcbUkYcQ6+0le90Wfn/gebH7m37gR98THSl
         0wc77C2e+aWYYvIT2gtJt7Yh1T+Zh3bJJupjfdasvUi/GJESiR6Uh45x1dVnymDr6+ck
         S7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xVn1wMxF612KR4qd3v/+ZpMRoNnQHSmut43e76ryAy0=;
        b=r6tBCBz1sOKa5fjy4ON1HGVCZGkOzDMIdRWWkayDhqwnZR/d7lOPRejg2pvWEGGhBe
         QjVdBHqVsZNLbb8aeW7qvI5XoJwkJUth8lNNXKvsAG9zWuRShuG+FsNk/8ZEIl6lhzia
         Pj2JB+RVbNnHV2PeirdbiYm0TH6PrtnWMqV43BGXto17G4sCFTAJ8JDRyMvdWbwjphoS
         o6eFDXxXauGxtngeTg91Kv6a0Kjva9BlkeASVhA+nf9KgRWmF8JK21CskUdWdImTSEhn
         +YTJpL5u7x3cv6ISVMOTWJqnfbHQFVXWT5WkcRSSkk24ECsJvtiDshME2GxBmXSuEWQ6
         115g==
X-Gm-Message-State: AOAM533jC0uyVqOgMImqybwJ9T0pNAKJxA6wXzAMAcEWcN65mY92h5YS
        AYGsK/nrmv41iMHsZE/px8HSBBW5rfjaNCbx9nCcZcXt1zZxNQ==
X-Google-Smtp-Source: ABdhPJyafnvQkHJQjBbud1GeweU7pR4nWug53MC0s3SnkvN9veseeb871oyKcvVs1bCnP7grujMZwj/vGB9np4QEeN0=
X-Received: by 2002:a25:73c7:: with SMTP id o190mr23466905ybc.108.1641463760658;
 Thu, 06 Jan 2022 02:09:20 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 Jan 2022 15:39:09 +0530
Message-ID: <CA+G9fYtaoxVF-bL40kt=FKcjjaLUnS+h8hNf=wQv_dKKWn_MNQ@mail.gmail.com>
Subject: txtimestamp.c:164:29: warning: format '0' expects argument of type
 'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long int'} [-Wformat=]
To:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While building selftests the following warnings were noticed for arm
architecture on Linux stable v5.15.13 kernel and also on Linus's tree.

arm-linux-gnueabihf-gcc -Wall -Wl,--no-as-needed -O2 -g
-I../../../../usr/include/    txtimestamp.c  -o
/home/tuxbuild/.cache/tuxmake/builds/current/kselftest/net/txtimestamp
txtimestamp.c: In function 'validate_timestamp':
txtimestamp.c:164:29: warning: format '0' expects argument of type
'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
int'} [-Wformat=]
  164 |   fprintf(stderr, "ERROR: 0 us expected between 0 and 0\n",
      |                           ~~^
      |                             |
      |                             long unsigned int
      |                           0
  165 |     cur64 - start64, min_delay, max_delay);
      |     ~~~~~~~~~~~~~~~
      |           |
      |           int64_t {aka long long int}
txtimestamp.c: In function '__print_ts_delta_formatted':
txtimestamp.c:173:22: warning: format '0' expects argument of type
'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
int'} [-Wformat=]
  173 |   fprintf(stderr, "0 ns", ts_delta);
      |                    ~~^      ~~~~~~~~
      |                      |      |
      |                      |      int64_t {aka long long int}
      |                      long unsigned int
      |                    0
txtimestamp.c:175:22: warning: format '0' expects argument of type
'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
int'} [-Wformat=]
  175 |   fprintf(stderr, "0 us", ts_delta / NSEC_PER_USEC);
      |                    ~~^
      |                      |
      |                      long unsigned int
      |                    0

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
https://builds.tuxbuild.com/23HFntxpqyCx0RbiuadfGZ36Kym/

metadata:
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  git commit: 734eb1fd2073f503f5c6b44f1c0d453ca6986b84
  git describe: v5.15.13
  toolchain: gcc-11
  kernel-config: https://builds.tuxbuild.com/23HFntxpqyCx0RbiuadfGZ36Kym/config


# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake

tuxmake --runtime podman --target-arch arm --toolchain gcc-10 \
 --kconfig https://builds.tuxbuild.com/23HFntxpqyCx0RbiuadfGZ36Kym/config \
  dtbs dtbs-legacy headers kernel kselftest kselftest-merge modules

--
Linaro LKFT
https://lkft.linaro.org
