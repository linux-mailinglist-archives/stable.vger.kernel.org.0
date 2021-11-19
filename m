Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC65456903
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 05:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhKSET4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 23:19:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11746 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229812AbhKSETz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 23:19:55 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ1ti8B020985;
        Fri, 19 Nov 2021 04:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=wWNq4kpBFDnAeqinz9FY+XbX5er29HmTnjXK3wLWq2Q=;
 b=sC93j2wLbajm/N/b0BwVfn0o3H3K8lXp2Jlo3ZEn8SiSw70Bl9GRVf/57LEASKSm0p43
 YjPXBpbuB71l269jkB9av1//D0eRfmt7hH4aNFsjrlR6XxGvicj4xGjYMKHcV9tkGoKL
 uGJeomMP7U3mZNx/ZEaz3YCygYJIW5uBfKPk42mlGTY/CLkcsggTnCz1n1WZCXdnDb8E
 LP5lEerV07689e3YMr0iuUh8tNWggKBKAgQ3hN+sZdlJomI5RHeKKllB4zw5yaxJlYNe
 62onzV2N0782SnwYIOhqVrMb2UUVMCM4LIYfDxvnV76/anIX0dpsqJMqncljUO8qsAcJ gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyucjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBLV020431;
        Fri, 19 Nov 2021 04:16:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:49 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwQ024731;
        Fri, 19 Nov 2021 04:16:49 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-6;
        Fri, 19 Nov 2021 04:16:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        njavali@marvell.com, aeasi@marvell.com, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: fix mailbox direction flags in qla2xxx_get_adapter_id()
Date:   Thu, 18 Nov 2021 23:16:35 -0500
Message-Id: <163729506336.21244.8728411946157258386.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211108183012.13895-1-emilne@redhat.com>
References: <20211108183012.13895-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: uoz7hQAj_VIme48CNq1C5eIjdsxi1Rxv
X-Proofpoint-GUID: uoz7hQAj_VIme48CNq1C5eIjdsxi1Rxv
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Nov 2021 13:30:12 -0500, Ewan D. Milne wrote:

> The SCM changes set the flags in mcp->out_mb instead of mcp->in_mb
> so the data was not actually being read into the mcp->mb[] array from
> the adapter.
> 
> 

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: fix mailbox direction flags in qla2xxx_get_adapter_id()
      https://git.kernel.org/mkp/scsi/c/392006871bb2

-- 
Martin K. Petersen	Oracle Linux Engineering
