Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C6030CB9F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbhBBTbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233495AbhBBN6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:58:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E329564FF0;
        Tue,  2 Feb 2021 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273560;
        bh=3U0MsKFZ6jZdT/tWymIAFZBHCGQ7wHMXvj6Cm2T4Fjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVp1gnfCmyDSs2u/zjQe862mnArzF8jtOhDW4KqIYcl/TZjNALtJH7DTy5zfebHdu
         fv2lH1H69sa/RtHLifIHQ/NPj0ggzg3qt0r23zQun/ENdNjXSqcJEERIBo4s2ZO2qn
         JoXC9xMGJvddt5//dOcF/+Fa5/hzNQ7xX8150wCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Aviraj CJ <acj@cisco.com>
Subject: [PATCH 5.4 01/61] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Tue,  2 Feb 2021 14:37:39 +0100
Message-Id: <20210202132946.546768538@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit b59e286be280fa3c2e94a0716ddcee6ba02bc8ba upstream.

Based on RFC7112, Section 6:

   IANA has added the following "Type 4 - Parameter Problem" message to
   the "Internet Control Message Protocol version 6 (ICMPv6) Parameters"
   registry:

      CODE     NAME/DESCRIPTION
       3       IPv6 First Fragment has incomplete IPv6 Header Chain

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aviraj CJ <acj@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/icmpv6.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -137,6 +137,7 @@ struct icmp6hdr {
 #define ICMPV6_HDR_FIELD		0
 #define ICMPV6_UNK_NEXTHDR		1
 #define ICMPV6_UNK_OPTION		2
+#define ICMPV6_HDR_INCOMP		3
 
 /*
  *	constants for (set|get)sockopt


