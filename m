Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A642138A87
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 06:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725268AbgAMFAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 00:00:13 -0500
Received: from mail02.vodafone.es ([217.130.24.81]:22156 "EHLO
        mail02.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgAMFAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 00:00:13 -0500
IronPort-SDR: 6lLlv9pt45Ja1QotnZOJ8kPm2+ynjT7QYXJovuaKFBYD4h3+sdXRwxArbrbMgCqFdRZ1fjL3qK
 zJ9n2HWT7P+w==
IronPort-PHdr: =?us-ascii?q?9a23=3AZyep3RANpB5ag0tKS77kUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSPT8r8bcNUDSrc9gkEXOFd2Cra4d0KyM7fGrBjxIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfL1/IA+ooQjQssQajolvJ6UswR?=
 =?us-ascii?q?bVv3VEfPhby3l1LlyJhRb84cmw/J9n8ytOvv8q6tBNX6bncakmVLJUFDspPX?=
 =?us-ascii?q?w7683trhnDUBCA5mAAXWUMkxpHGBbK4RfnVZrsqCT6t+592C6HPc3qSL0/RD?=
 =?us-ascii?q?qv47t3RBLulSwLMTk1/nzLhcNqiaJaoAutqgJ4w47OeIGVM+B+cbnBfdwEXG?=
 =?us-ascii?q?ZOQMBRWzVdD4Ogc4sAFfYOPeZGoIn4uVQOqwe+CRCyC+Pp0zNGgXj23ask3O?=
 =?us-ascii?q?UhCA3JwgogFM8KvHnasNn5KKIeXOaox6fK0DrDdetb1zn95ojSbB4vouyCUr?=
 =?us-ascii?q?1sfsTe0kQvCwHIgUmMpYD5Iz+ZyOIAuHWb4ep6UuKvjnYqpRtvrTiz2MgskJ?=
 =?us-ascii?q?TCiYISylDC+iVy3YE4JcWmR05nf9GkCpVRtyacN4t5Wc4iQ3potz0mxbEcpZ?=
 =?us-ascii?q?G7ey0KxI4nxx7ccvGKdZWD7BH7VOuJPzt0mXBodKiiixu87USs0PPwW8au3F?=
 =?us-ascii?q?tEridIlMTHuGoX2BzJ8MeHT+Nw/kKm2TmSyQ/e8vpEIUUolarDLJ4h36Iwmo?=
 =?us-ascii?q?ITsUvdGi/2n137jKqMeUUl/uio8froYrH6qpKTLYN0lAb+Pbk0lcyxBuQ4NB?=
 =?us-ascii?q?YBU3KF9uSnzLHj/Ev5T6tWjvAujKXVrZLXKd4GqqO3HwNZyJgv5hmlAzqo0N?=
 =?us-ascii?q?kUhXwHI0hEeBKDgYjpIVbOIPXgAPennVusjClkx+rIP73mBJXNIWPOkLf6fb?=
 =?us-ascii?q?lm90FQ0hY8zdda555OCrEBI+r/WlXtu9zAEh85Lwu0zv78CNVhzIwRQmaPDb?=
 =?us-ascii?q?GCPaPMvl+H+PgvL/OPZIALojb9LeYq5/r0gX8+g18dcvrh4ZxCc2yxFPBrC1?=
 =?us-ascii?q?uWbGCqgdobF2oO+A0kQ7/QhUWGQAJUMk6/Q68mrg48Do3uWZ/OWo23n7uH0y?=
 =?us-ascii?q?e4HoZcbUhJD1mNFTHjcIDSCNkWbyfHGsJ9nyZMar+nRMd1zRyyuRXlzLxoBu?=
 =?us-ascii?q?rP8CZevpXmkth2sb6A3Sou/CB5Wp3Om1qGSHt5yzhQHzI=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FHWQBE+BtemCMYgtkUBTMYGwEBAQE?=
 =?us-ascii?q?BAQEFAQEBEQEBAwMBAQGBewIBARcBAYEjAgmBTVIgEpNQgU0fg0OLY4EAgx4?=
 =?us-ascii?q?VhggTDIFbDQEBAQEBNQIBAYRATgEXgQ8kOgQNAgMNAQEFAQEBAQEFBAEBAhA?=
 =?us-ascii?q?BAQEBAQYNCwYphUqCHQweAQQBAQEBAwMDAQEMAYNdBxkPOUoMQAEOAVODBIJ?=
 =?us-ascii?q?LAQEzhSOXWAGNBA0NAoUdgjUECoEJgRojgTQCAQGMFxqBQT+BIyGCKwgBggG?=
 =?us-ascii?q?CfwESAWyCSIJZBI1CEiGBB4gpmBeCQQR2iUyMAoI3AQ+IAYQxAxCCRQ+BCYg?=
 =?us-ascii?q?DhE6BfaM3V4EMDXpxMxqCJhqBIE8YDYgbji1AgRYQAk+JLoIyAQE?=
X-IPAS-Result: =?us-ascii?q?A2FHWQBE+BtemCMYgtkUBTMYGwEBAQEBAQEFAQEBEQEBA?=
 =?us-ascii?q?wMBAQGBewIBARcBAYEjAgmBTVIgEpNQgU0fg0OLY4EAgx4VhggTDIFbDQEBA?=
 =?us-ascii?q?QEBNQIBAYRATgEXgQ8kOgQNAgMNAQEFAQEBAQEFBAEBAhABAQEBAQYNCwYph?=
 =?us-ascii?q?UqCHQweAQQBAQEBAwMDAQEMAYNdBxkPOUoMQAEOAVODBIJLAQEzhSOXWAGNB?=
 =?us-ascii?q?A0NAoUdgjUECoEJgRojgTQCAQGMFxqBQT+BIyGCKwgBggGCfwESAWyCSIJZB?=
 =?us-ascii?q?I1CEiGBB4gpmBeCQQR2iUyMAoI3AQ+IAYQxAxCCRQ+BCYgDhE6BfaM3V4EMD?=
 =?us-ascii?q?XpxMxqCJhqBIE8YDYgbji1AgRYQAk+JLoIyAQE?=
X-IronPort-AV: E=Sophos;i="5.69,427,1571695200"; 
   d="scan'208";a="323785011"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 13 Jan 2020 06:00:11 +0100
Received: (qmail 13859 invoked from network); 12 Jan 2020 03:50:08 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <stable@vger.kernel.org>; 12 Jan 2020 03:50:08 -0000
Date:   Sun, 12 Jan 2020 04:50:07 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     stable@vger.kernel.org
Message-ID: <16879860.243035.1578801008654.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

