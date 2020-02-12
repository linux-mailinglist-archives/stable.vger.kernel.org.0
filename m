Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E913F15B53C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 00:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgBLXvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 18:51:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbgBLXvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 18:51:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CNmW7R168540;
        Wed, 12 Feb 2020 23:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=QLhh8UmAV7YRTHOjwX6Fb5zdFuR2cSV8o26nu2Xmi7s=;
 b=pJFCj0FmICfKzzXVAXeGrxr7T/8L7UU/9gixU/xp2hSLltPc1O22GArkjbCBgtiOK71s
 s9+ABE3NB1GnhUJ6LM14+pCQAEQlDQhkIxwzC6/fzBh++jW1wKAiKM/gfaFXZgtjMXwN
 dy+bihur8SxaAcxRGmM/u5ZsOJLkUGscJosH8MzXWfiDSdtXfvx79qcYOkgp0ro8ednx
 /mfFgm3N1VEVPr6BVi6aVvtF4BstzYl7gJN1/O0dTR+Jn9d9xi+DjQ6sp5vOmrjgS0GS
 D07G04j+omgBzaOTonh60yjQxapcu5r+TJ/TzOxhcOtFws3YRCKaGfCQMWnoEoczh2Q5 ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y2k88ec1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 23:51:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CNl6o8027945;
        Wed, 12 Feb 2020 23:51:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2y4kah5ddt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Feb 2020 23:51:28 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01CNpQuB012262;
        Wed, 12 Feb 2020 23:51:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 15:51:26 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org,
        Pavel Zakharov <pavel.zakharov@delphix.com>,
        Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "target/core: Inline transport_lun_remove_cmd()"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200210051202.12934-1-bvanassche@acm.org>
Date:   Wed, 12 Feb 2020 18:51:24 -0500
In-Reply-To: <20200210051202.12934-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 9 Feb 2020 21:12:02 -0800")
Message-ID: <yq1wo8rs6tf.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002120165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002120165
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Bart,

> Commit 83f85b8ec305 postponed the percpu_ref_put(&se_cmd->se_lun->lun_ref)
> call from command completion to the time when the final command reference is
> dropped. That approach is not compatible with the iSCSI target driver
> because the iSCSI target driver keeps the command with the highest stat_sn
> after it has completed until the next command is received (see also
> iscsit_ack_from_expstatsn()). Fix this regression by reverting commit
> 83f85b8ec305.

Applied to 5.6/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
