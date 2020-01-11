Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA05D138474
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 02:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgALBwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 20:52:42 -0500
Received: from mail3-bck.iservicesmail.com ([217.130.24.85]:48625 "EHLO
        mail3-bck.iservicesmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731893AbgALBwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 20:52:42 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jan 2020 20:52:42 EST
IronPort-SDR: nspYCaEwA9XE8P0UsFHS57/Wsn8GOi44z0TEdZkR7lzQcC/vXGUiwlGXJVd43CMeDGvnpG/300
 HRY/SPsT/xgQ==
IronPort-PHdr: =?us-ascii?q?9a23=3A1ZXFPR8Uo3T5DP9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B31OIcTK2v8tzYMVDF4r011RmVBN6dsawawLGG+4nbGkU4qa6bt34DdJEeHz?=
 =?us-ascii?q?Qksu4x2zIaPcieFEfgJ+TrZSFpVO5LVVti4m3peRMNQJW2aFLduGC94iAPER?=
 =?us-ascii?q?vjKwV1Ov71GonPhMiryuy+4ZLebxhGiTanf79/LRS7oQrfu8QVnIBvNrs/xh?=
 =?us-ascii?q?zVr3VSZu9Y33loJVWdnxb94se/4ptu+DlOtvwi6sBNT7z0c7w3QrJEAjsmNX?=
 =?us-ascii?q?s15NDwuhnYUQSP/HocXX4InRdOHgPI8Qv1Xpb1siv9q+p9xCyXNtD4QLwoRT?=
 =?us-ascii?q?iv6bpgRBnvhCkaKzE26mTXi8xpgK9FpxKhvQR/w4nOYI6PKPpxYLrRcs0cRW?=
 =?us-ascii?q?ZYQstRSzBBDZmgYIsPEeUBOPhXr4/hp1cXsxS+AxCgCuToyj9OmHD33bQ23P?=
 =?us-ascii?q?onEQrb2AAtEc4CvGjRoNjzKawcU/26zLPQwDvNb/1Wwynz5ovVfB8uvf6CUq?=
 =?us-ascii?q?l9cdbTxEYzCw/JkkmcpZLjMjiI1uoNqW+b7+94WOy1lWEntx9+oiKyzcgsjY?=
 =?us-ascii?q?nJgI0VwU3D+CVh3ok1OcO3SFR1YN6jFptQuDqXN4ttQsw5X25kojo1yroDuZ?=
 =?us-ascii?q?KhfCgKy40qyhjCYPKEa4iF+gzvWPuTLDtimX5odq6ziwys/UWv0OHxWMm53V?=
 =?us-ascii?q?BXpSRfiNbMrGoC1xnL58iCTfty41mu1C6U1wDW9uFEOUc0lbfHK5I5wr4/iJ?=
 =?us-ascii?q?4TsUPbEy/zgkr2jauWdl869eis9+jqba/qpoGbN4BpkA7+PKMumsqhDugiLA?=
 =?us-ascii?q?cORHCX+eW61LL94U30WKtGguA0n6XDrZzXK9gXqrSnDwJayIou5RayAy+j0N?=
 =?us-ascii?q?sCnHkHKFxFeAiAj4jsI1zOOO73DeuhjFS2njZrwPbGPrL6D5XNNXjMi6vuca?=
 =?us-ascii?q?xh5E5bzQo/19Bf55FMBrEbPP3zQlPxtMDfDhIhKAy03/zoB8551owAQm+PHK?=
 =?us-ascii?q?CZP73IsVOS5eIgPfOMZIkLtzb5MfQl4OTujXBq0WMaKLK11JETZVimEfl8ZU?=
 =?us-ascii?q?aUe3zhhpEGC2hZhAcmSP3Wjwi6XCJefT6NWKQzrmUjBZ6rF5jEQI+tm7aK3C?=
 =?us-ascii?q?STEZhfZ2QAAVeJRyTGbYKBDs8BdC+IavBmlDNMAaCsV4I7yhaouyf60LBsaO?=
 =?us-ascii?q?HT/2sYtsSwh5BO++TPmERrpnRPBMOH3jTWFzl5?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HVAQArehpelyMYgtlMGBoBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBAREBAQECAgEBAQGBaAQBAQEBCwEBGwQBgSmBTVIgEpNQgU0fg0O?=
 =?us-ascii?q?LY4EAgx4VhgcUDIFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQE?=
 =?us-ascii?q?FBAEBAhABAQEBAQYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVO?=
 =?us-ascii?q?DBIJLAQEznXsBjQQNDQKFHYI7BAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ?=
 =?us-ascii?q?/ARIBbIJIglkEjUISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAO?=
 =?us-ascii?q?EToF9ozdXdAGBHnEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2HVAQArehpelyMYgtlMGBoBAQEBAQEBAQEDAQEBAREBA?=
 =?us-ascii?q?QECAgEBAQGBaAQBAQEBCwEBGwQBgSmBTVIgEpNQgU0fg0OLY4EAgx4VhgcUD?=
 =?us-ascii?q?IFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQEFBAEBAhABAQEBA?=
 =?us-ascii?q?QYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVODBIJLAQEznXsBj?=
 =?us-ascii?q?QQNDQKFHYI7BAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ/ARIBbIJIglkEj?=
 =?us-ascii?q?UISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAOEToF9ozdXdAGBH?=
 =?us-ascii?q?nEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,423,1571695200"; 
   d="scan'208";a="323111585"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 12 Jan 2020 02:47:39 +0100
Received: (qmail 15556 invoked from network); 11 Jan 2020 23:10:55 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <stable@vger.kernel.org>; 11 Jan 2020 23:10:55 -0000
Date:   Sun, 12 Jan 2020 00:10:52 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghsbchk@gmail.com>
To:     stable@vger.kernel.org
Message-ID: <2680044.89047.1578784254863.JavaMail.cash@217.130.24.55>
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

