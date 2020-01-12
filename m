Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD71F138924
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 02:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgAMBEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 20:04:24 -0500
Received: from mail01.vodafone.es ([217.130.24.71]:10658 "EHLO
        mail01.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgAMBEX (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 12 Jan 2020 20:04:23 -0500
IronPort-SDR: 0yAOOd7NXJNvwfPpwRw/AWUFV+JVGqbzK+ypf6Z3exqedDnRoKfWGKxJ4mO6O8UC4r6R3OflDk
 aAHX4642SUGw==
IronPort-PHdr: =?us-ascii?q?9a23=3AO17WgRHsRDLaLRrasv9GKp1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ7zoMSwAkXT6L1XgUPTWs2DsrQY0rGQ6f6xEjdYqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba58IRmsswnct80bjYRsJ6ot1x?=
 =?us-ascii?q?DEvmZGd+NKyG1yOFmdhQz85sC+/J5i9yRfpfcs/NNeXKv5Yqo1U6VWACwpPG?=
 =?us-ascii?q?4p6sLrswLDTRaU6XsHTmoWiBtIDBPb4xz8Q5z8rzH1tut52CmdIM32UbU5Ui?=
 =?us-ascii?q?ms4qt3VBPljjoMOzg+/G/KlsN/lqdboRK4qxFhxI7UepmVNP1kfqzHYdMVW3?=
 =?us-ascii?q?NNUdhXVyBYHo68c5cPAPAdMuZYsYb9okUBrR2iBQW1GuzvzCZEiHjx3a08ze?=
 =?us-ascii?q?sgERjK0xImH9kTtHjZosn5OLsXXe2z0aLGzyjMb+lO1Dnz6IbIaA4vr/KRU7?=
 =?us-ascii?q?1/bcXfxlIiFx/Hg1qMtYDpIy+Z2voLvmOG7+RgT+Wvi2s/pg9rvDev2tkjip?=
 =?us-ascii?q?PUjY0VzVDE8yp5y5syKN2gVkF7fcCrEIFetiGdMYt2TdgvQ2FzuCkh1rIKo4?=
 =?us-ascii?q?K0fC8PyJg9xx7faOWKfo6V6RzgTOacOSl0iG9ndb6lmhq//1SsxvfiWsS7yl?=
 =?us-ascii?q?pHoCpIn9/RvX4XzRPT8NKISv5l80ek3jaAyh7c5/lfIUAxiarbM5khwqMslp?=
 =?us-ascii?q?YLsUTMACv2mELuga+TbEok++yo6/75bbXiupOROJV4ih/5MqszgMO/D+M4Mg?=
 =?us-ascii?q?4QUGSB5+u8z6Xv/Uz/QLpUkv07irfVvI3YKMgBu6K0DRNZ3pw95xuwFTur3t?=
 =?us-ascii?q?QVkWECLF1feRKHi4bpO0vJIPD9Ffq/m0qjkCt1yPDcMLzhBZPNLnfYnbfhZr?=
 =?us-ascii?q?Zy8FJTxBAvwtBY4pJYELEBIPHrVk/rqNPYFgM5MxCzw+v/Fdt9ypkRVnmLAq?=
 =?us-ascii?q?CHK67Sr1CI6fw1I+WWZ48apiz9K/476P7ql3M5nkUdfab6lacQPUukF/5iLm?=
 =?us-ascii?q?2Hbnf2xNQMC2EHukw5VuO5slCaVS9vYCOKUr4x/HkED4SpRdPbS5ygmqOG2i?=
 =?us-ascii?q?i7BZddZmNuBVWFEHOufIKBDaQiciWXd/dsjjEeHYemTYBpgQmjqALg1L1hIc?=
 =?us-ascii?q?LU4ScT85nk0Z515LuAxlkJ6TVoApHEgCm2RGZukzZTH2c7?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FHSwAWwRtemCMYgtkUBjMYGwEBAQE?=
 =?us-ascii?q?BAQEFAQEBEQEBAwMBAQGBewIBgT0CCYFNUiASk1CBTR+DQ4tjgQCDHhWGCBM?=
 =?us-ascii?q?MgVsNAQEBAQE1AgEBhEBOAReBDyQ6BA0CAw0BAQUBAQEBAQUEAQECEAEBAQE?=
 =?us-ascii?q?BBg0LBimFSoIdDB4BBAEBAQEDAwMBAQwBg10HGQ85SkwBDgFTgwSCSwEBM4U?=
 =?us-ascii?q?fl3IBjQQNDQKFHYItBAqBCYEaI4E0AgEBjBcagUE/gSMhgisIAYIBgn8BEgF?=
 =?us-ascii?q?sgkiCWQSNQhIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4ROgX2?=
 =?us-ascii?q?jN1eBDAh/cTMagiYagSBPGA2IG44tQIEWEAJPi2KCMgEB?=
X-IPAS-Result: =?us-ascii?q?A2FHSwAWwRtemCMYgtkUBjMYGwEBAQEBAQEFAQEBEQEBA?=
 =?us-ascii?q?wMBAQGBewIBgT0CCYFNUiASk1CBTR+DQ4tjgQCDHhWGCBMMgVsNAQEBAQE1A?=
 =?us-ascii?q?gEBhEBOAReBDyQ6BA0CAw0BAQUBAQEBAQUEAQECEAEBAQEBBg0LBimFSoIdD?=
 =?us-ascii?q?B4BBAEBAQEDAwMBAQwBg10HGQ85SkwBDgFTgwSCSwEBM4Ufl3IBjQQNDQKFH?=
 =?us-ascii?q?YItBAqBCYEaI4E0AgEBjBcagUE/gSMhgisIAYIBgn8BEgFsgkiCWQSNQhIhg?=
 =?us-ascii?q?QeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4ROgX2jN1eBDAh/cTMag?=
 =?us-ascii?q?iYagSBPGA2IG44tQIEWEAJPi2KCMgEB?=
X-IronPort-AV: E=Sophos;i="5.69,427,1571695200"; 
   d="scan'208";a="304395897"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 13 Jan 2020 02:04:21 +0100
Received: (qmail 23444 invoked from network); 12 Jan 2020 06:49:48 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <Stable@vger.kernel.org>; 12 Jan 2020 06:49:48 -0000
Date:   Sun, 12 Jan 2020 07:49:47 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghsbchk@gmail.com>
To:     Stable@vger.kernel.org
Message-ID: <18493302.20321.1578811788421.JavaMail.cash@217.130.24.55>
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

